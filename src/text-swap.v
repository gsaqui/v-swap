import os
import regex
import net.http
import json

struct Is_Good {
	errorcode     int
	error_message string
	shorturl      string
}

fn main() {

	for {
		
		src := os.input('')
		if src == 'exit' || src == '' {
			break
		}
		lines := src.split_into_lines()
		new_str := src.replace('(', '[').replace(')', ']')
		// query:= r".*\((.*)\)"
		query := r'(.*)\[(.*)\]'
		mut re := regex.regex_opt(query) or {
			panic(err)
		}
		re.match_string(new_str)
		if re.groups.len > 3 {
			first := new_str[re.groups[0]..re.groups[1]]
			mut second := new_str[re.groups[2]..re.groups[3]]
			second = second.replace('#/', '')
			short_link := http.get('https://is.gd/create.php?format=json&url=$second') or {
				panic(err)
			}
			// println(temp)
			shorturl := json.decode(Is_Good, short_link.text) or {
				println('failed to decode a story')
				panic(err)
			}
			println('$first ($shorturl.shorturl)')

		}
	}
}
