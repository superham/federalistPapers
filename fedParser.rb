# Alex Kaariainen Fed Papers Project
require 'erb'
# --------------------------------------------------------
# ------------------- federalist class -------------------
class Fed
  def initialize(name, number, title, pub, text)
    @author = name
    @number = number
    @title = title
    @pub = pub
    @text = text
  end

  # getters
  def get_author() return @author end
  def get_number() return @number end
  def get_title() return @title end
  def get_pub() return @pub end
  def get_text() return @text end
end
# ------------------- end of Fed class -------------------
# --------------------------------------------------------

# --------------------------------------------------------
# ---------------- local methods -------------------------
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
# -------------------------------------------------

# -------------------------------------------------
# ---------------start of main program ------------

lines = Array.new # array to hold the file's lines in

File.readlines("fed.txt").each do |line|  # puts each line from file into 'lines' array
  lines.push(line)
end

fedObjs = Array.new # create an array of Fed objects, each elemet will represent a letter
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
}

fileHtml = File.new("output.html","w+")
fileHtml.puts "<html>
  <head><title>Federalist Index</title></head>
  <body>"
fileHtml.puts "<h3>Federalist Index</h3>
<table>
  <tr>
    <th>No.</th>
    <th>Author</th>
    <th>Title</th>
    <th>Pub</th>
  </tr>"

  # put each fed data into an html table row
  fedObjs.each_with_index {
    |item,index|
    fileHtml.puts "<tr><td>"
    fileHtml.puts  fedObjs[index].get_number().to_s
    fileHtml.puts  "</td><td>"
    fileHtml.puts  fedObjs[index].get_author().to_s
    fileHtml.puts  "</td><td>"
    fileHtml.puts  fedObjs[index].get_title().to_s
    fileHtml.puts  "</td><td>"
    fileHtml.puts  fedObjs[index].get_pub().to_s
    fileHtml.puts  "</td></tr>"
  }
  fileHtml.puts "</table></body></html>" #end the html doc <-- actully not necessary
  # --------------------end of main program-----------------
  # --------------------------------------------------------
