### 
### A demo of spork/cjanet
### 
### First, make sure you have `janet-lang/spork` in your project:
### $ jpm install spork
###  OR
### $ jpm install spork --local
### 
### Transpile this file to C with the following shell command:
### $ janet hello-cjanet.janet > hello.c
### 
### To compile the transpiled C to a .so file using jpm:
###
### 1. You must have a `project.janet` in your project's root. The one provided here is:
### 
### # project.janet
### ---
### (declare-project
###   :name "cjanet-demo")
###   
### (declare-native
###   :name "hello"
###   :source ["hello.c"])
### ---  
###   
### 2. Run `$ jpm build` in your project root.
### 
### To use the compiled `hello.so` file in a Janet REPL:
###
### $ janet
### Janet 1.35.2-fda0a081 linux/x64/gcc - '(doc)' for help
### repl:1:> (use ./build/hello)
### @{_ @{:value <cycle 0>} hello @{:private true} hello-name @{:private true} triple @{:private true}}
###
### The following is annotated with the C output of each form in the
### transpiled `hello.c` file.
###

(import spork/cjanet :as c)

(c/include <janet.h>)
# #include <janet.h>

(c/@ define DEFINITION 3)
# #define DEFINITION 3

(c/cfunction
  hello :static
  "Says Hello World"
  [] -> Janet
  (printf "Hello, world\n")
  (return (janet_wrap_nil)))
# /* Says Hello World */
# static Janet hello()
# {
#   printf("Hello, world\n");
#   return janet_wrap_nil();
# }
# 
# JANET_FN(_generated_cfunction_hello,
#         "(hello)", 
#         "Says Hello World")
# {
#   janet_fixarity(argc, 0);
#   return hello();
# }

(c/cfunction
  hello-name :static
  "Greets the name passed in"
  [name:string] -> Janet
  (printf "Hello, %s\n" name)
  (return (janet_wrap_nil)))
# /* Greets the name passed in */
# static Janet hello_name(JanetString name)
# {
#   printf("Hello, %s\n", name);
#   return janet_wrap_nil();
# }
# 
# JANET_FN(_generated_cfunction_hello_name,
#         "(hello-name name:string)", 
#         "Greets the name passed in")
# {
#   janet_fixarity(argc, 1);
#   JanetString name = janet_getstring(argv, 0);
#   return hello_name(name);
# }

(c/function
  multiply_by_3 :static
  ``
 This function is available to other functions in this file, but
 will not be exported in the JANET_MODULE_ENTRY (unless it is
 manually added to the *cfun-list* dynamic variable).
 ``
  [n:int] -> int
  (return (* n DEFINITION)))
# /* This function is available to other functions in this file, but
# will not be exported in the JANET_MODULE_ENTRY (unless it is
# manually added to the *cfun-list* dynamic variable). */
# static int multiply_by_3(int n)
# {
#   return n * DEFINITION;
# }

(c/cfunction
  triple-integer :static
  "Multiplies an integer by 3"
  [n:int] -> Janet
  (def return_int:int (multiply_by_3 n))
  (return (janet_wrap_number return_int)))
# /* Multiplies an integer by 3 */
# static Janet triple_integer(int n)
# {
#   int return_int = multiply_by_3(n);
#   return janet_wrap_number(return_int);
# }
# 
# JANET_FN(_generated_cfunction_triple_integer,
#         "(triple-integer n:int)", 
#         "Multiplies an integer by 3")
# {
#   janet_fixarity(argc, 1);
#   int n = janet_getinteger(argv, 0);
#   return triple_integer(n);
# }

(c/module-entry "hello")
# JANET_MODULE_ENTRY(JanetTable *env) {
#   JanetRegExt cfuns[] = {
#     JANET_REG("hello", _generated_cfunction_hello), 
#     JANET_REG("hello-name", _generated_cfunction_hello_name), 
#     JANET_REG("triple-integer", _generated_cfunction_triple_integer), 
#     JANET_REG_END
#   };
#   janet_cfuns_ext(env, "hello", cfuns);
# }

