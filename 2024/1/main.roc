app [main!] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import cli.Stdout
import "input.txt" as input : Str

main! = |_args|
    result =
        input
        |> Str.split_on "\n"
        |> List.map process_line
        |> List.walk ([], []) walk_step
        |> sort_numbers
        |> diff_numbers
        |> List.sum

    Stdout.line!(Num.to_str result)

diff_numbers = |(list1, list2)|
    List.map2 list1 list2 |num1, num2|
        Num.abs_diff num1 num2

sort_numbers = |(list1, list2)|
    (List.sort_desc list1, List.sort_desc list2)

walk_step = |(list1, list2), nums|
    (List.concat(list1, List.take_first nums 1), List.concat(list2, List.take_last nums 1))

process_line = |line|
    line
    |> Str.split_on "   "
    |> List.map |string|
        Result.with_default(Str.to_u32 string, 0)
