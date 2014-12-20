# Insert string to file
# file: file name
# name: tag identifier in file
# string: string to insert
def append2file(file, name, string)
	_block_start = "# #{name} added by chef {"
	_block_end = "# }\n"
	_block = "#{_block_start}\n#{string}\n#{_block_end}\n"

	bash "Remove #{name} from #{file}" do
		code <<-EOC
			perl -0777 -pi -e 's/\n*#{_block_start}.*?#{_block_end}//gs' #{file}
		EOC
		only_if "cat #{file} | grep -q '#{_block_start}'"
	end
	bash "Add #{name} to #{file}" do
		code <<-EOC
			echo '' >> #{file}
			echo '#{_block_start}' >> #{file}
			echo '#{string}' >> #{file}
			echo '#{_block_end}' >> #{file}
		EOC
		not_if "cat #{file} | grep -q '#{_block_start}'"
	end
end

# Insert file to file
# file: file name
# name: tag identifier in file
# template: file to insert
def appendTemplate2file(file, name, template)
	_block_start = "# #{name} added by chef {"
	_block_end = "# }\n"

	bash "Remove #{name} from #{file}" do
		code <<-EOC
			perl -0777 -pi -e 's/\n*#{_block_start}.*?#{_block_end}//gs' #{file}
		EOC
		only_if "cat #{file} | grep -q '#{_block_start}'"
	end
	bash "Add #{name} to #{file}" do
		code <<-EOC
			echo '' >> #{file}
			echo '#{_block_start}' >> #{file}
			cat #{template} >> #{file}
			echo '#{_block_end}' >> #{file}
		EOC
		not_if "cat #{file} | grep -q '#{_block_start}'"
	end
end
