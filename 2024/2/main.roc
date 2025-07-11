app [main!] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import cli.Stdout
import "input.txt" as problem_input : Str

main! = |_args|
    safe_report_count =
        problem_input
        |> process_input
        |> List.count_if(|report| is_report_safe({ report, direction: Unknown }))

    Stdout.line!("safe report count: ${Inspect.to_str(safe_report_count)}")

is_report_safe = |{ report, direction }|
    when report is
        [] -> Bool.false
        [_] -> Bool.true
        [num1, num2, ..] ->
            new_direction =
                when direction is
                    Unknown -> if num1 > num2 then Desc else if num1 < num2 then Asc else Unknown
                    Asc -> Asc
                    Desc -> Desc

            abs_diff = Num.abs_diff(num1, num2)
            is_diff_valid = 0 < abs_diff and abs_diff < 4

            if !is_diff_valid or (direction == Desc and num1 < num2) or (direction == Asc and num1 > num2) then
                Bool.false
            else
                is_report_safe({ report: List.drop_first(report, 1), direction: new_direction })

process_input = |input|
    input
    |> Str.split_on("\n")
    |> List.map(
        |str_line|
            Str.split_on(str_line, " ")
            |> List.keep_oks(
                |str_num|
                    Str.to_i64(str_num),
            ),
    )
