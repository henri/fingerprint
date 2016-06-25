# Copyright, 2016, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# This script takes a given path, and renames it with the given format. 
# It then ensures that there is a symlink called "latest" that points 
# to the renamed directory.

require 'samovar'

module Fingerprint
	module Command
		class Check < Samovar::Command
			self.description = "Check two fingerprints for additions, removals and changes."
			
			options do
				option "-x/--extended", "Include extended information about files and directories."
				option "-a/--additions", "Report files that have been added to the copy."
				option "--fail-on-errors", "Exit with non-zero status if errors are encountered."
				
				option "--progress", "Print structured progress to standard error."
			end
			
			one :master, "The fingerprint which represents the original data."
			one :copy,  "The fingerprint which represents a copy of the data."
			
			def invoke(parent)
				options = @options.dup
				options[:output] = parent.output
				
				error_count = Checker.check_files(@master, @copy, options)

				if @options[:fail_on_errors]
					abort "Data inconsistent, #{error_count} error(s) found!" if error_count != 0
				end
			end
		end
	end
end
