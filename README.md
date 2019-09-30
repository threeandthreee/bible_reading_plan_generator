# Bible reading plan generator
Generate a bible reading plan based off of a configuration file, attempting to keep days of reading a consistent length.

## Instructions
`bundle install`

<<<<<<< HEAD
`ruby generate.rb <blueprint> [<output file>]`

Example: `ruby generate.rb traditional ./traditional_plan.txt`

If no blueprint specified, *simple* is used. If no output file specified, the plan will be written to `./plan.txt`.

## Blueprints
Blueprints are YAML files that the reading plan generator works off of. At the topmost level they are a hash associating **timeframes** with a list of **reading streams**. The blueprints included in this project cover a pretty good range of usage. Please reference them if you have any interest in creating your own blueprints.

#### Timeframes
Timeframes are a month or range of months. Months can be represented by number or English name. For example: `2`, `Feb`, and `February` all resolve to the month of February. A range is represented by a two item array of the start and end months, or as a hash with the key `from` for the starting month and `to` for the ending month. For example: `[1, 12]`, `[Jan, Dec]`, and `{from: January, to: December]}` are all valid ways to represent the range from January through December.

#### Reading Streams
Reading streams allow for parallel sets of reading. The traditional reading plan of reading the Old Testament and New Testament in parallel can be achieved by setting up two streams on one time frame, one for the Old Testament and the other for the New.

A reading stream is a list of books or book ranges. Books can be represented by their number, short name, or full name. The names and numbering are strictly based on what's in the xml bible we parsed, so reference that if you're creating your own blueprint (or just use numbers). For example: `1`, `Gen`, and `Genesis` all resolve to the book of Genesis.

A range of books is represented the same way as a range of months: a two item array or a hash with keys `from` and `to`. For example, the Torah (Genesis through Deuteronomy) can be represented: `[1, 5]`, `{from: Genesis, to: Deuteronomy}`, or listed individually without a range such as: `Gen, Exod, Lev, Num, Deut`.
=======
`ruby main.rb`
>>>>>>> dc29e4f87921be2ab51f6db7620a16bee914744c
