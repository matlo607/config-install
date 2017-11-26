set pagination off
set trace-commands on
set logging file gdb.txt
set logging on
set breakpoint pending on

# more readable but take a lot of space
set print pretty on

# Tell GDB where to find the source files
#set substitute-path ${bad_path}/src ${good_path}/src
