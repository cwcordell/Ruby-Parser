There are two ways to utilize the compiler tester code:

1. Through the interface
    a. Run the "Run.rb" file.
    b. Enter the file path for the file to be compiled.

2. Utilizing the class
    a. Include the "Analyzer.rb" file in another ruby file
    b. Instantiate it with "Analyzer.new(filePath)"



There are two possible outcomes:

1. A message, "The program compiled successfully!" will display if the file is without detectable errors.

2. A message, "The file contains errors:" will display followed by one of two types of errors.
    a. A message, "Parse Error: Invalid syntax on line #, 'line contents'".
    b. A trace will display if the file parses correctly but has token sequence errors, like
        "Error at token index 3: Missing Simi-Colon!
         Error at token index 3: No statements!
         Error at token index 3: Not a Program!"