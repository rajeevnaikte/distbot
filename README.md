# distbot
Distributed/parallel execution of Robot Framework test suites using multiple docker containers
# How it works
Start multiple docker containers of this (e.g. docker-compose distbot --scale=4), with all pointing to a shared volume folder, where the robot framework test suites are stored. Each robot file will be run in a separate process/container. This program will automatically distribute the suites among the docker containers and run in parallel. Once all suites are completed, it will execute 'rebot' of robot framework to combine all the reports. The report will be stored in same shared volume folder (You can also specify different location using --outputdir <a href="http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#all-command-line-options">argument of robot frameowrk</a>).
# Usage
Run the docker container with -h argument to see all options.<br/>
<br/>
usage: -e ENV [options] main_suite [robot arguments]<br/>
<br/>
positional arguments:<br/>
  main_suite            Folder name containing all the robot framework scripts.<br/>
<br/>
optional arguments:<br/>
  -h, --help            show this help message and exit<br/>
  -e E                  dev, stage, prod etc. This value will be available as variable ENV.<br/>
  -b B                  This value will be available as variable BROWSER.<br/>
  -u U                  This value will be available as variable USERNAME.<br/>
  -p P                  This value will be available as variable PASSWORD.<br/>
  --mode {sequential,distributed}<br/>
  --max-cpu-percent MAX_CPU_PERCENT<br/>
                        Program will stop spawning new process when cpu usage reaches this value.<br/>
  --max-memory MAX_MEMORY<br/>
                        Program will stop spawning new process when memory usage reaches this value.<br/>
  --max-processes MAX_PROCESSES<br/>
                        Program will stop spawning new process when running processes count is this value.<br/>
  -d OUTPUTDIR, --outputdir OUTPUTDIR<br/>
                        Directory to save report files. Default is workingdir/report<br/>
  -s SUITE, --suite SUITE<br/>
                        Only run suites matching this value

# Assistant mode
There is an assistant library here to use during development. This program will keep the robot framework running, and allow you to type in the keywords from terminal/cmd prompt. It is a good tool for web-developers while coding to see the effect while trying out differnet logics.
Starting assistant is simple. e.g. - <br/>
python distbot/distbot.py -e local -b ff Assistant
