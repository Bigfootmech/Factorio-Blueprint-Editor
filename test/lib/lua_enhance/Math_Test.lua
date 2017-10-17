
local lu = require('luaunit')
local Math = require('lib.lua_enhance.Math')

TestRound = {}
    function TestRound:testRoundZero()
        lu.assertEquals(Math.round(0),0)
    end
    function TestRound:testRoundOne()
        lu.assertEquals(Math.round(1),1)
    end
    function TestRound:testRoundHalf()
        lu.assertEquals(Math.round(0.5),1)
    end
    function TestRound:testRoundLessHalf()
        lu.assertEquals(Math.round(0.49),0)
    end
    function TestRound:testRoundNineAndAHalf()
        lu.assertEquals(Math.round(9.5),10)
    end
    function TestRound:testRoundMoreThanMinusHalf()
        lu.assertEquals(Math.round(-0.49),0)
    end
    function TestRound:testRoundMinusHalf()
        lu.assertEquals(Math.round(-0.5),0)
    end
    function TestRound:testRoundLessThanMinusHalf()
        lu.assertEquals(Math.round(-0.51),-1)
    end
    
TestRoundDecimal = {}
    function TestRoundDecimal:testRoundTenth()
        lu.assertEquals(Math.round(0.05, 1), 0.1)
    end
    function TestRoundDecimal:testRoundTens()
        lu.assertEquals(Math.round(5, -1), 10)
    end
    
lu.LuaUnit.run()