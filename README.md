# wait-for-docker
`wait-for-docker` is a pure bash for controlling the start-up order in dcoker-compose. It can be used:
1. to see if we can access specific IP and port
2. to check the avaliability of functional model, like DB
3. to check wether some specific file exist

Since it is a pure bash script, it does not have any external dependencies.

*Update*: add c code and cmake file as an optional method, add Dockerfile to compile C code. 

# Usage

# Example

```
wait-for-it.sh file [-rxw] [ti timeout] [-- command args]
-h,       show the help message
-x,       wait for the path to be executable
-r,       wait for the path to be readable
-w,       wait for the path to be writable

```
