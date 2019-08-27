# distbot
Distributed/parallel execution of Robot Framework test suites using multiple docker containers
# Video
https://www.youtube.com/watch?v=KL4V0QkMMVc
# How it works
Start multiple docker containers of <a href="https://hub.docker.com/r/rajeevnaikte/distbot">rajeevnaikte/distbot</a> (e.g. ```docker-compose up --scale=4```), with all pointing to a shared volume folder, where the robot framework test suites are stored, and set argument ```--mode distributed``` (e.g. in docker-compose.yml file). Each robot suite/file will be run in a separate process/container. This program will automatically distribute the suites among the docker containers and run in parallel (without need of a master node). Also, in each container multiple suites can be run in parallel as per the --max-* configurations mentioned below. Once all suites are completed, one of the container will execute ```rebot``` of robot framework to combine all the reports. The report will be stored in same shared volume folder (You can also specify different location using --outputdir <a href="http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#all-command-line-options">argument of robot frameowrk</a>).
# Usage
```pip install robotframework-distbot```<br/>
Run the docker container or ```python -m distbot``` with -h argument to see all options of the progam.<br/>
```
usage: -e ENV [options] main_suite [robot arguments]

positional arguments:
  main_suite            Folder name containing all the robot framework scripts.

optional arguments:
  -h, --help            show this help message and exit
  -e E                  dev, stage, prod etc. This value will be available as variable ENV.
  -b B                  This value will be available as variable BROWSER.
  -u U                  This value will be available as variable USERNAME.
  -p P                  This value will be available as variable PASSWORD.
  --mode {sequential,distributed}
  --max-cpu-percent MAX_CPU_PERCENT
                        Program will stop spawning new process when cpu usage reaches this value.
  --max-memory MAX_MEMORY
                        Program will stop spawning new process when memory usage reaches this value.
  --max-processes MAX_PROCESSES
                        Program will stop spawning new process when running processes count is this value.
  -d OUTPUTDIR, --outputdir OUTPUTDIR
                        Directory to save report files. Default is workingdir/report
  -s SUITE, --suite SUITE
                        Only run suites matching this value
```
# Assistant mode
There is an assistant library here to use during development. This program will keep the robot framework running, and allow you to type in the keywords from terminal/cmd prompt. It is a good tool for web-developers while coding to see the effect while trying out differnet logics.<br/>
Starting assistant is simply using keywork 'start assistant'. e.g. in this repo there is file Assistant/assistant.robot. Just run that - <br/>
```python -m distbot -e local -b ff Assistant```
