app [main!] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import cli.Stdout
import "input.txt" as input : Str

main! = |_args|
    input_list =
        input
        |> Str.split_on("\n")
        |> List.map(process_line)
        |> List.walk(([], []), walk_step)

    total_distance =
        input_list
        |> sort_numbers
        |> diff_numbers
        |> List.sum

    _res1 = Stdout.line!("Total distance: ${Num.to_str(total_distance)}")

    similarity_score =
        input_list
        |> calculate_similarity_score
        |> List.sum

    Stdout.line!("Similarity: ${Num.to_str(similarity_score)}")

calculate_similarity_score = |(list1, list2)|
    List.map2(
        list1,
        list2,
        |num1, _num2|
            occurences =
                list2
                |> List.keep_if(|num| num == num1)
                |> List.len
                |> Num.to_u32

            Num.mul(num1, occurences),
    )

diff_numbers = |(list1, list2)|
    List.map2(
        list1,
        list2,
        |num1, num2|
            Num.abs_diff(num1, num2),
    )

sort_numbers = |(list1, list2)|
    (List.sort_desc list1, List.sort_desc list2)

walk_step = |(list1, list2), nums|
    (List.concat(list1, List.take_first nums 1), List.concat(list2, List.take_last nums 1))

process_line = |line|
    line
    |> Str.split_on("   ")
    |> List.map |string|
        Result.with_default(Str.to_u32 string, 0)
