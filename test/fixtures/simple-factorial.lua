a = 0

function factorial (n)
    if n == 0 then
      return 1
    else
      return n * factorial(n-1)
    end
  end

a = factorial(10)