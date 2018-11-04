require 'erb'

# ------------------- federalist class -------------------
class Fed
  def initialize(name, number, title, pub, text)
    @author = name
    @number = number
    @title = title
    @pub = pub
    @text = text
  end

  #mutators
  def add_data(name, number, title, pub, text)
    @author = author
    @number = number
    @title = title
    @pub = pub
    @text = text
  end

  def get_author()
    return @author
  end
  def get_number()
    return @number
  end
  def get_title()
    return @title
  end
  def get_pub()
    return @pub
  end
  def get_text()
    return @text
  end
end
# ------------------- end of class -------------------

# ---------------- methods -----------------
def get_number(line)  # checks string for number
  line.match(/\d+/) # /any number/
end

def get_title(lines,index) # pass array with first line index. returns title string
  index += 1
  if lines[index].match(/^\n/) != nil # if first line is nil, skip
    returnStr = lines[index]
    index += 1
    #concadinate strings onto returnStr until a new-line char is found
    while (lines[(index+1)].match(/^\n/) == nil) #checks for start of line new char
      returnStr += lines[index].match(/./).string # gets everything
      index += 1
    end
  else # if the first line is non-nil
      returnStr = lines[index]
      index += 1
    #concadinate strings onto returnStr until a new-line char is found
    while (lines[(index+1)].match(/^\n/) == nil) # checks for start of line new char
      returnStr += lines[index].match(/./).string # gets everything
      index += 1
    end
  end
  return returnStr
end

def get_pub(lines,index) # pass array with first line index. returns returns publication string
    index += 1
    if lines[index].match(/^\n/) != nil # if first line is nil, skip
      returnStr = lines[index]
      index += 1
      #concadinate strings onto returnStr until a new-line char is found
      while (lines[(index)].match(/^\n/) == nil) #checks for start of line new char
        if(lines[(index+1)].match(/^\n/) == nil)
          returnStr = lines[(index+1)]
        end
        index += 1
      end
    else
        index += 1
        returnStr = lines[index]
      #concadinate strings onto returnStr until a new-line char is found
      while (lines[(index)].match(/^\n/) == nil) #checks for start of line new char
      if(lines[(index+1)].match(/^\n/) == nil)
        returnStr = lines[(index+1)]
      end
        index += 1
      end
    end
    return returnStr
end

def get_author(lines,index) # pass array with first line index. returns author string
  index += 1
  if lines[index].match(/^\n/) != nil # if first line is nil, skip
    returnStr = lines[index]
    index += 1
    #concadinate strings onto returnStr until a new-line char is found
    while (lines[(index)].match(/^\n/) == nil) #checks for start of line new char
      if(lines[(index+1)].match(/^\n/) == nil)
        returnStr = lines[(index+3)]
      end
      index += 1
    end
  else
      index += 1
      returnStr = lines[index]
    #concadinate strings onto returnStr until a new-line char is found
    while (lines[(index)].match(/^\n/) == nil) #checks for start of line new char
    if(lines[(index+1)].match(/^\n/) == nil)
      returnStr = lines[(index+3)]
    end
      index += 1
    end
  end
  return returnStr
end

def author_line(lines,index)
  index += 1
  if lines[index].match(/^\n/) != nil # if first line is nil, skip
    returnStr = lines[index]
    index += 1
    #concadinate strings onto returnStr until a new-line char is found
    while (lines[(index)].match(/^\n/) == nil) #checks for start of line new char
      if(lines[(index+1)].match(/^\n/) == nil)
        returnStr = lines[(index+3)]
      end
      index += 1
    end
  else
      index += 1
      returnStr = lines[index]
    #concadinate strings onto returnStr until a new-line char is found
    while (lines[(index)].match(/^\n/) == nil) #checks for start of line new char
    if(lines[(index+1)].match(/^\n/) == nil)
      returnStr = lines[(index+3)]
    end
      index += 1
    end
  end
  return index
end

def get_text(lines,index)
  index = author_line(lines,index)
returnStr=""
cond=true
while cond == true
  index += 1
  returnStr += lines[index]
  if lines[index].match(/PUBLIUS./) != nil
    return returnStr
  end
end

  return returnStr
end
# ---------------- end of methods -----------------

# ---------------- start of logic -----------------

# array to hold file individual lines in
lines = Array.new

# puts each line from file into 'lines' array
File.readlines("fed.txt").each do |line|
  lines.push(line)
end

fedObjs = Array.new
count=0
lines.each_with_index {# go through 'lines' array line by line
  |item,index|
  if item.match(/FEDERALIST/) != nil  #check if the current line starts width "FEDERALIST"
    number = get_number(lines[index])
    title = get_title(lines,index) # returns title
    pub = get_pub(lines,index)   # returns publication
    author = get_author(lines,index)# returns author
    text = get_text(lines, index) # returns the text
    fedObjs[count] = Fed.new(author, number, title, pub, text)
    count += 1
  end
} # end of loop

# instance variables for erb
@number = fedObjs[0].get_number()
@author = fedObjs[0].get_author()
@title = fedObjs[0].get_title()
@pub = fedObjs[0].get_pub()

# render template
template = File.read('./template.html.erb')
result = ERB.new(template).result(binding)

# write result to file
File.open('output.html', 'w+') do |f|
  f.write result
end
# ------------------- end of logic -------------------
