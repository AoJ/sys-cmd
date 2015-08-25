
debug linux commands
```
  $ strace ln -snf new current 2>&1 | grep link
  unlink("current")         = 0
  symlink("new", "current") = 0
```  
