# A demo of spork/cjanet

This is an _extremely_ simple "Hello, world" demonstrating the most basic possible use of [janet-lang/spork's cjanet module](https://github.com/janet-lang/spork/cjanet). CJanet is a DSL written in Janet that compiles to C.

## Usage instructions

First, make sure you have `janet-lang/spork` in your project:

```console
$ jpm install spork
```
or
```
 $ jpm install spork --local
```

Transpile this file to C with the following shell command:

```console
$ janet hello-cjanet.janet > hello.c
```

To compile the transpiled C to a .so file using jpm:

1. You must have a `project.janet` in your project root. The one provided here is:
 
```janet
# project.janet
 (declare-project
   :name "cjanet-demo")
   
 (declare-native
   :name "hello"
   :source ["hello.c"])
 ```
   
2. Run `$ jpm build` command in your project root.
 
 To use the compiled `hello.so` file in a Janet REPL:
```console 
$ janet
Janet 1.35.2-fda0a081 linux/x64/gcc - '(doc)' for help
repl:1:> (use ./build/hello)
@{_ @{:value <cycle 0>} hello @{:private true} hello-name @{:private true} triple @{:private true}}
```

The [hello-cjanet.janet](hello-cjanet.janet) file is annotated with the C output of each form in the transpiled `hello.c` file.

