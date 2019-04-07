import os
import sqlite3
import json
import time
import uuid
import logging

class TasksDB(object):
    def __init__(self, directory):
        if not os.path.exists(directory):
            os.makedirs(directory)
        self.dbPath = directory + '/tasks.db'
        self.conn = sqlite3.connect(self.dbPath)
        with self.conn:
            self.conn.execute('''
                Create table if not exists Tasks (
                    task text not null,
                    status integer default 0,
                    worker text,
                    groupid integer not null
                );
            ''')
            self.conn.execute('''
                Create table if not exists TaskGroups (
                    groupid integer not null,
                    parentGroupId integer not null,
                    status integer default 0
                );
            ''')
            self.conn.execute('''
                Create table if not exists TasksLoadHistory (
                    commands text not null,
                    worker text not null,
                    status integer default 0,
                    loadDateTime timestamp default current_timestamp,
                    unique (commands, status) on conflict replace
                );
            ''')

    def __del__(self):
        self.conn.close()

    def isTasksLoaded(self):
        rows = self.conn.execute('select task from Tasks where status is not 2 limit 1;').fetchall()
        if len(rows) == 0:
            rows = self.conn.execute("select * from TasksLoadHistory where loadDateTime > datetime('now', '-30 seconds')").fetchall()
            if len(rows) == 0:
                return False
        return True

    def loadTasks(self, tasks):
        uId = uuid.uuid1().hex
        with self.conn:
            try:
                self.conn.execute('insert into TasksLoadHistory(commands,worker) values (?,?)', (json.dumps(tasks),uId))
            except:
                time.sleep(1)
                return
        time.sleep(0.5)
        if len(self.conn.execute('select * from TasksLoadHistory where worker=?', (uId,)).fetchall())==0:
            attempts = 0
            while len(self.conn.execute('select 1 from Tasks t where t.status=0 limit 1;').fetchall())==0:
                time.sleep(0.5)
                if attempts > 5:
                    break
                attempts = attempts + 1
            return
        with self.conn:
            self.conn.execute('delete from Tasks')
            self.conn.execute('delete from TaskGroups')
            self.parseTasks(tasks, 0, 0)
            
    def parseTasks(self, tasks, taskGroup, parentGroup):
        groupTasks = None
        nextGroup = taskGroup + 1
        getTaskGroup = None
        if 'sequential' in tasks:
            groupTasks = tasks['sequential']
            nextGroup = taskGroup + len(groupTasks) + 1
            getTaskGroup = lambda group: group+1
        elif 'parallel' in tasks:
            groupTasks = tasks['parallel']
            getTaskGroup = lambda group: group
        for task in groupTasks:
            taskGroup = getTaskGroup(taskGroup)
            self.conn.execute('''insert into TaskGroups(groupId,parentGroupId) 
            select ?,? 
            where not exists(select 1 from TaskGroups 
            where groupid=? and parentGroupId=?);''', (taskGroup,parentGroup,taskGroup,parentGroup))
            if isinstance(task, basestring) or isinstance(task, str) or isinstance(task, unicode):
                self.conn.execute('insert into Tasks(task,groupid) values (?,?);', (task,taskGroup))
            else:
                nextGroup = self.parseTasks(task, nextGroup, taskGroup)
        
        return nextGroup
            
    def getTaskToWorkOn(self):
        uId = uuid.uuid1().hex
        rowid = None
        while len(self.conn.execute('select 1 from Tasks t where t.status=0 limit 1;').fetchall()) > 0:
            rows = self.conn.execute('''select t.rowid from Tasks t
            where t.status=0 and t.groupid in (
                select tg.groupid from TaskGroups tg
                where not exists (
                    select 1 from TaskGroups tg2
                    where tg2.groupid < tg.groupid and tg2.parentgroupid=tg.parentgroupid
                    and tg2.status is not 2
                )
            ) limit 1;''').fetchall()
            if len(rows) == 0:
                time.sleep(5)
            else:
                with self.conn:
                    self.conn.execute('''update Tasks 
                    set status=1,worker=? 
                    where rowid=?;''', (uId, rows[0][0],))
                time.sleep(0.5)
                rows = self.conn.execute('select rowid from Tasks where status=1 and worker=?;', (uId,)).fetchall()
                if len(rows) > 0:
                    rowid = rows[0][0]
                    break
        return rowid

    def getTask(self, rowid):
        return self.conn.execute('select task from Tasks where rowid=?', (rowid,)).fetchall()[0][0]
        
    def finishTask(self, task):
        with self.conn:
            self.conn.execute('update Tasks set status=2 where rowid=?;', (task,))
        groupId = self.conn.execute('select groupid from Tasks where rowid=?;', (task,)).fetchall()[0][0]
        rows = self.conn.execute('select 1 from Tasks where groupid=? and status is not 2', (groupId,)).fetchall()
        if len(rows) is 0:
            with self.conn:
                self.conn.execute('''update TaskGroups set status=2 
                where groupid=?;''', (groupId,))
            with self.conn:
                self.conn.execute('''update TaskGroups set status=2 
                where not exists(
                    select 1 from TaskGroups tg2 
                    where tg2.parentGroupId=groupId and tg2.status is not 2
                );''')
            with self.conn:
                self.conn.execute('''update TasksLoadHistory set status=2 
                where not exists(
                    select 1 from Tasks t where t.status is not 2
                )
                ''')

    def printTableData(self):
        print(str(os.getpid())+'|'+str(self.conn.execute('select * from TaskGroups').fetchall()))
        print(str(os.getpid())+'|'+str(self.conn.execute('select * from Tasks').fetchall()))
        return
