cjsv.rb is the entry point
-- Watches over a directory and parses continously, even-driven.
-- On file change, creates a *FileParser* lib/file_parser.rb

CJSV::FileParser
-- Transform each line in a appropriate instance of (ArgsLineParser, CoffeeLineParser, RenderLineParser or CjsvLineParser)  using *LineParserFactory* lib/factory_line_parser.rb
-- Generates a function body with the help of LineRenderer