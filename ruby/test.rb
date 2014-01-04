#!/usr/bin/env ruby
module x
    def abc.f
    end
    def f
    end
    class f
    end
end
x::abc.f
x::f
new x::f()
