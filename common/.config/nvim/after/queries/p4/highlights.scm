[
  "action"
  "apply"
  "default"
  "enum"
  "error"
  "extern"
  "exit"
  "in"
  "inout"
  "out"
  "return"
  "select"
  "state"
  "table"
  "this"
  "transition"
] @keyword

[
  "abstract"
  "type"
  "typedef"
] @keyword.type

[
  "bit"
  "bool"
  "const"
  "control"
  "false"
  "header"
  "header_union"
  "int"
  "list"
  "match_kind"
  "package"
  "parser"
  "string"
  "struct"
  "void"
  "true"
  "tuple"
  "varbit"
  "valueset"
] @type.builtin

[
  "else"
  "if"
  "switch"
] @keyword.conditional

[
  "for"
  "continue"
  "break"
] @keyword.repeat

[
  (preproc_define)
  (preproc_define)
  (preproc_undef)
  (preproc_if)
  (preproc_ifdef)
  (preproc_line)
] @keyword.directive

(preproc_include) @keyword.import

[
  "!"
  "~"
  "*"
  "/"
  "%"
  "+"
  "-"
  "|+|"
  "|-|"
  "<<"
  ">>"
  "<="
  ">="
  "<"
  ">"
  "!="
  "=="
  "&"
  "^"
  "|"
  "++"
  "&&"
  "||"
  "?"
  "="
  "*="
  "/="
  "%="
  "+="
  "-="
  "|+|="
  "|-|="
  "<<="
  ">>="
  "&="
  "|="
  "^="
] @operator

(comment) @comment

(type_ref
  (type_name) @type)

(derived_type_declaration
  [
    (header_type_declaration
      (name) @type)
    (header_union_declaration
      (name) @type)
    (struct_type_declaration
      (name) @type)
    (enum_declaration
      (name) @type)
  ])

(expression
  (type_name
    (prefixed_type
      (identifier) @type
      (#match? @type "^\\s*[A-Z]"))))

(type_ref
  [
    (base_type
      ["<" ">"] @punctuation.bracket)
    (specialized_type
      ["<" ">"] @punctuation.bracket)
    (array_type
      ["[" "]"] @punctuation.bracket)
    (p4list_type
      ["<" ">"] @punctuation.bracket)
    (tuple_type
      ["<" ">"] @punctuation.bracket)
  ])

(type_parameters
  [
    "<" @punctuation.bracket
    ">" @punctuation.bracket
    (name) @type
  ])

(function_prototype
  . (identifier) @type)

(function_prototype
  (name) @function)

(integer_literal) @number

(parameter
  (declarator) @variable.parameter)

(struct_field
  (declarator
    (name
      (non_type_name
        (identifier) @variable.member))))
