#
# 
# hikaru shinkai
#
# ruby version
# ruby 2.1.2p95
#
# exec sample
# ruby sudoku.rb input.txt
#
def printMatrix(mat)
  output = File.open("output.txt",'w')

  mat.each_with_index { |row, i|
    puts "-"*31 if i % 3 == 0
    row.each_with_index { |elm, j|
      print (j%3==0 ? "|" : "") + elm.to_s.center(3)
    }
    puts "|"
    output.puts row.join
  }
  puts "-"*31
  output.close
end

class Sudoku
  def initialize()
    @nfilled=0
    @mat, @rowfill, @colfill, @boxfill = 4.times.collect { |j| 9.times.collect { |i| Array.new(9, (j==0) ? 0 : false) } }
    @boxi = 9.times.collect { |i| 9.times.collect { |j| 3*(i/3)+j/3  } }
    @matindex = 9.times.collect { |i| 9.times.collect { |j| [i,j] } }.flatten(1)
  end

  def readProblem(filename)
    open(filename) {|file|
      chars=[]
      @matindex.each { |row, col|
        chars = file.gets.chomp.split("") if col==0
        setValue(row, col, chars[col].to_i ) if chars[col]!=" "
      }
    }
  end

  def printState()
    printMatrix(@mat)
  end

  def isEmpty?(i, j)
    @mat[i][j]==0
  end

  def canPut?(i, j, val)
    !(@rowfill[i][val] || @colfill[j][val] || @boxfill[@boxi[i][j]][val])
  end

  def setValue(i, j, val)
    k = (val!=0) ? val : @mat[i][j]
    @nfilled += (val!=0) ? 1 : -1
    @mat[i][j] = val
    @rowfill[i][k] = @colfill[j][k] = @boxfill[@boxi[i][j]][k] = (val!=0)
  end

  def getNextCand()
    @matindex.collect { |row,col|
      [isEmpty?(row,col) ? 1.upto(9).count { |v| canPut?(row,col,v) } : 9999, row, col]
    }.min[1..2]
  end

  def searchRec(i, j, val)
    return true if @nfilled == 81
    empt = isEmpty?(i, j)

    if empt
      return false if !canPut?(i, j, val)
      setValue(i, j, val)
    end
    nexti, nextj = getNextCand()
    1.upto(9){ |nextval|
      return true if searchRec(nexti, nextj, nextval)
    }
    setValue(i, j, 0) if empt
    return false
  end

  def search()
    for i in 1..9
      break if searchRec(0,0,i)
    end
  end

end
# Main routine
sudoku=Sudoku.new
sudoku.readProblem(ARGV[0])
puts "Problem (Input)"
sudoku.printState
puts "Solving..."
sudoku.search
puts "Solution"
sudoku.printState
