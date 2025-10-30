# gem5-bridge

The following commands are the full list of possible `gem5-brdige` calls.

```
Usage: gem5-bridge[call type] <command> [arguments]

Call types:
    --addr [address override] (default)
        Use the address based invocation method. The default address is 0xffff0000.
    --inst
        Use the instruction based invocation method.

Commands:
    addsymbol <address> <symbol>
        Adds a symbol with address "address" to gem5's symbol table
    checkpoint [delay [period]]
        After delay (default 0) take a checkpoint, and then optionally every period after
    dumpresetstats [delay [period]]
        After delay (default 0) dump and reset the stats, and then optionally every period after
    dumpstats [delay [period]]
        After delay (default 0) dump the stats, and then optionally every period after
    exit [delay]
        Exit after delay, or immediately
    fail <code> [delay]
        Exit with failure code code after delay, or immediately
    hypercall [hypercall number]
        define behaviour upon exit
    initparam [key]
        optional key may be at most 16 characters long
    loadsymbol 
        load a preselected symbol file into gem5's symbol table
    readfile 
        read a preselected file from the host and write it to stdout
    resetstats [delay [period]]
        After delay (default 0) reset the stats, and then optionally every period after
    sum <a> <b> [c [d [e [f]]]]
        Sum a-f (defaults are 0), for testing purposes
    workbegin [workid][threadid]
        Exit immediately
    workend [workid [threadid]]
        Exit immediately
    writefile <filename> [host filename]
        Write a file to the host, optionally with a different name

All times in nanoseconds!
```