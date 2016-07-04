def could_have_ruby_code path
  return false unless File.file? path
  return false if path.include? 'Gemfile'
  return false if path.include? '.gitignore'
  return true if path.include? '.rb'
  return true if path.include? '.erb'
  return true if path.include? '.haml'
  return true unless path.include? '.'
  false
end

def contains_running_byebug line
  index = line.index 'byebug'

  return false unless line.include? 'byebug'
  #
  # return false unless ['#', '{', ' '].include? line[index - 1]
  #
  # return true if line.split(/".*#[{].*[}].*"/).map{|str| str.index 'byebug'}.compact.empty?
  #
  # return false if line.split(/".*"/).map{|str| str.index 'byebug'}.compact.empty?
  #
  # return false if line.split(/'.*'/).map{|str| str.index 'byebug'}.compact.empty?
  #
  # return false if line.split(/%.\(.*\)/).map{|str| str.index 'byebug'}.compact.empty?

  true
end

def user_says_so line, path
  puts "in #{path}"
  puts line
  puts 'Do you want to remove this line? (y/n)'
  answer = gets
  puts ['yes', 'y'].include? answer.gsub("\n", '')
  ['yes', 'y'].include? answer.gsub("\n", '')
end



Dir.glob("**/*").each do |path|
  if could_have_ruby_code path
    file_lines = File.readlines(path)
    file_lines.delete_if{|line| contains_running_byebug(line) and user_says_so line, path}
    File.write(path, file_lines.join(''))
  end
end

