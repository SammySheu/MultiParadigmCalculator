(** Converts an integer list to a string representation *)
let list_to_string lst =
  let elements = List.map string_of_int lst in
  "[" ^ String.concat ", " elements ^ "]"

(** Converts a float list to a string representation *)
let float_list_to_string lst =
  let elements = List.map (Printf.sprintf "%.2f") lst in
  "[" ^ String.concat ", " elements ^ "]"

(* ============================================================================
 * MEAN CALCULATION
 * ============================================================================ *)

(**
 * Calculates the arithmetic mean (average) of a list of integers.
 * 
 * Uses List.fold_left to sum all elements in a single pass,
 * demonstrating the functional approach to aggregation.
 * 
 * @param lst List of integers
 * @return The mean as a float, or 0.0 for empty list
 *)
let calculate_mean lst =
  match lst with
  | [] -> 0.0
  | _ ->
    let sum = List.fold_left ( + ) 0 lst in
    let count = List.length lst in
    float_of_int sum /. float_of_int count

(* ============================================================================
 * MEDIAN CALCULATION
 * ============================================================================ *)

(**
 * Calculates the median of a list of integers.
 * 
 * The median is the middle value of a sorted list. For even-length lists,
 * it's the average of the two middle values.
 * 
 * Uses List.sort (which returns a new sorted list, preserving immutability)
 * and List.nth for indexed access.
 * 
 * @param lst List of integers
 * @return The median as a float, or 0.0 for empty list
 *)
let calculate_median lst =
  match lst with
  | [] -> 0.0
  | _ ->
    let sorted = List.sort compare lst in
    let n = List.length sorted in
    if n mod 2 = 1 then
      (* Odd length: return middle element *)
      float_of_int (List.nth sorted (n / 2))
    else
      (* Even length: average of two middle elements *)
      let mid1 = List.nth sorted (n / 2 - 1) in
      let mid2 = List.nth sorted (n / 2) in
      (float_of_int mid1 +. float_of_int mid2) /. 2.0

(* ============================================================================
 * MODE CALCULATION
 * ============================================================================ *)

(**
 * Groups consecutive equal elements and counts their frequencies.
 * 
 * This is a helper function that uses pattern matching and recursion
 * to build a frequency map from a sorted list.
 * 
 * @param sorted_lst A sorted list of integers
 * @return List of (value, frequency) pairs
 *)
let rec count_frequencies sorted_lst =
  match sorted_lst with
  | [] -> []
  | [x] -> [(x, 1)]
  | x :: (y :: _ as rest) ->
    if x = y then
      (* Same as next element, increment count in recursive result *)
      match count_frequencies rest with
      | (v, c) :: tl when v = x -> (v, c + 1) :: tl
      | other -> (x, 1) :: other
    else
      (* Different from next, start new count *)
      (x, 1) :: count_frequencies rest

(**
 * Calculates the mode(s) of a list of integers.
 * 
 * The mode is the most frequently occurring value. This function handles
 * multimodal data by returning all values that share the maximum frequency.
 * 
 * Uses functional composition:
 * 1. Sort the list (immutable operation)
 * 2. Count frequencies using recursion
 * 3. Find maximum frequency using fold
 * 4. Filter to get all values with max frequency
 * 5. Map to extract just the values
 * 
 * @param lst List of integers
 * @return Tuple of (mode values list, frequency)
 *)
let calculate_mode lst =
  match lst with
  | [] -> ([], 0)
  | _ ->
    let sorted = List.sort compare lst in
    let frequencies = count_frequencies sorted in
    
    (* Find the maximum frequency using fold *)
    let max_freq = 
      List.fold_left (fun acc (_, freq) -> max acc freq) 0 frequencies 
    in
    
    (* Filter to get all elements with maximum frequency, then extract values *)
    let modes = 
      frequencies
      |> List.filter (fun (_, freq) -> freq = max_freq)
      |> List.map fst
    in
    
    (modes, max_freq)

(* ============================================================================
 * ALTERNATIVE MODE IMPLEMENTATION USING ASSOCIATION LISTS
 * ============================================================================ *)

(**
 * Alternative mode calculation using association lists (dictionaries).
 * 
 * This demonstrates another functional approach using:
 * - List.assoc_opt for dictionary-like lookups
 * - Tail recursion for building the frequency map
 * - Higher-order functions for finding and filtering results
 *)
let calculate_mode_assoc lst =
  (* Build frequency map using tail recursion *)
  let rec build_freq_map acc remaining =
    match remaining with
    | [] -> acc
    | x :: rest ->
      let current_count = 
        match List.assoc_opt x acc with
        | Some c -> c
        | None -> 0
      in
      (* Remove old entry and add updated one *)
      let updated = 
        (x, current_count + 1) :: List.filter (fun (k, _) -> k <> x) acc 
      in
      build_freq_map updated rest
  in
  
  match lst with
  | [] -> ([], 0)
  | _ ->
    let freq_map = build_freq_map [] lst in
    let max_freq = 
      List.fold_left (fun acc (_, freq) -> max acc freq) 0 freq_map 
    in
    let modes = 
      freq_map
      |> List.filter (fun (_, freq) -> freq = max_freq)
      |> List.map fst
      |> List.sort compare  (* Sort for consistent output *)
    in
    (modes, max_freq)

(* ============================================================================
 * DISPLAY FUNCTIONS
 * ============================================================================ *)

(**
 * Formats the mode result as a string
 *)
let mode_to_string (modes, frequency) =
  match modes with
  | [] -> "No mode (empty dataset)"
  | [x] -> Printf.sprintf "%d (appears %d time%s)" x frequency 
           (if frequency = 1 then "" else "s")
  | _ -> Printf.sprintf "%s (each appears %d times)" 
         (list_to_string modes) frequency

(**
 * Analyzes a dataset and prints all statistics
 *)
let analyze_dataset name data =
  print_newline ();
  print_endline "============================================================";
  Printf.printf "Dataset: %s\n" name;
  print_endline "============================================================";
  Printf.printf "Data: %s\n" (list_to_string data);
  Printf.printf "Size: %d elements\n" (List.length data);
  print_endline "------------------------------------------------------------";
  
  (* Calculate and display mean *)
  let mean = calculate_mean data in
  Printf.printf "Mean: %.2f\n" mean;
  
  (* Calculate and display median *)
  let median = calculate_median data in
  Printf.printf "Median: %.2f\n" median;
  
  (* Calculate and display mode *)
  let mode_result = calculate_mode data in
  Printf.printf "Mode: %s\n" (mode_to_string mode_result);
  
  print_endline "============================================================"

(* ============================================================================
 * ADDITIONAL FUNCTIONAL DEMONSTRATIONS
 * ============================================================================ *)

(**
 * Demonstrates functional composition by creating a pipeline
 * that transforms and analyzes data in one expression.
 *)
let functional_pipeline data =
  let stats = 
    data
    |> (fun d -> (calculate_mean d, calculate_median d, calculate_mode d))
  in
  stats

(**
 * Demonstrates partial application by creating specialized functions
 *)
let analyze_with_prefix prefix =
  fun name data -> analyze_dataset (prefix ^ ": " ^ name) data

(* ============================================================================
 * INPUT PARSING
 * ============================================================================ *)

(**
 * Parses a comma-separated string into a list of integers.
 * 
 * Uses functional string processing with List.filter_map to convert
 * string elements to integers, filtering out invalid entries.
 *)
let parse_input input =
  String.split_on_char ',' input
  |> List.map String.trim
  |> List.filter_map (fun s ->
      try Some (int_of_string s)
      with Failure _ -> None)

(**
 * Displays statistics for a dataset in a formatted way
 *)
let display_statistics data =
  print_newline ();
  print_endline ("=" ^ String.make 59 '=');
  print_newline ();
  
  Printf.printf "Data: %s\n" (list_to_string data);
  Printf.printf "Size: %d elements\n" (List.length data);
  
  let mean = calculate_mean data in
  Printf.printf "Mean: %.2f\n" mean;
  
  let median = calculate_median data in
  Printf.printf "Median: %.2f\n" median;
  
  let mode_result = calculate_mode data in
  Printf.printf "Mode: %s\n" (mode_to_string mode_result);
  
  (* Create summary similar to Python version *)
  Printf.printf "\nSummary:\n";
  Printf.printf "  data: %s\n" (list_to_string data);
  Printf.printf "  size: %d\n" (List.length data);
  Printf.printf "  mean: %.2f\n" mean;
  Printf.printf "  median: %.2f\n" median;
  let (modes, freq) = mode_result in
  Printf.printf "  mode: %s\n" (list_to_string modes);
  Printf.printf "  mode_frequency: %d\n" freq;
  
  print_newline ();
  print_endline ("=" ^ String.make 59 '=');
  print_newline ()

(* ============================================================================
 * MAIN PROGRAM
 * ============================================================================ *)

let () =
  print_endline "This program uses the StatisticsCalculator to calculate the mean, median, and mode of a dataset.";
  
  (* Interactive loop *)
  let rec loop () =
    print_string "Enter a dataset (comma separated. e.g. 1,2,3,4,5) or 'q' to quit: ";
    flush stdout;
    
    let input = read_line () in
    
    if input = "q" || input = "Q" then
      ()
    else
      match parse_input input with
      | [] -> 
        print_endline "Error: No valid integers found. Please try again.";
        print_newline ();
        loop ()
      | data ->
        display_statistics data;
        loop ()
  in
  
  loop ()

