app [main!] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import cli.Stdout
import "input.txt" as problem_input : Str

main! = |_args|
    Stdout.line!(Inspect.to_str(parse_mul(problem_input)))

parse_mul = |input|
    input
    |> Str.split_on("mul(")
    |> List.keep_if(|s| Str.contains(s, ")"))
    |> List.keep_oks(
        |s|
            when Str.split_on(s, ")") is
                [str_inside_parenthesis, ..] -> parse_inside_parenthesis(str_inside_parenthesis)
                _ -> Err InvalidFormat,
    )
    |> List.sum

parse_inside_parenthesis = |str|
    when Str.split_on(str, ",") is
        [str1, str2] -> convert_string_list_to_int_list([str1, str2])
        _ -> Err InvalidFormat

convert_string_list_to_int_list = |str_list|
    when List.map(str_list, Str.to_u32) is
        [Ok num1, Ok num2] ->
            if validate_numbers_range([num1, num2]) then
                Ok (num1 * num2)
            else
                Err NumberOutOfRange

        _ -> Err InvalidNumStr

validate_numbers_range = |num_list|
    List.all(num_list, |num| (1 <= num) and (num <= 999))
