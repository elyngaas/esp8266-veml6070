-- quick and dirty code for VEML6070 UV-A Light Sensor 320-410nm
-- http://www.vishay.com/docs/84277/veml6070.pdf
-- el@ Datek Wireless AS
-- Doesn't use any bit manipulation so doesn't require bit module, but probably should :)

i2c_id = 0
sda = 5
scl = 4

i2c.setup(i2c_id, sda, scl, i2c.SLOW)

function veml6070()
    dev_addr = 0x38
-- Integration time ("exposure") Rset = 270Kohm = 5.265uW/cm2/step
--    itime = 0x02   -- 1/2T  = 56.25ms
    itime = 0x06   -- 1T    = 112.5ms    (default)
--    itime = 0x0A   -- 2T    = 225ms
--    itime = 0x0E   -- 4T    = 450ms
    i2c.start(i2c_id)
    i2c.address(i2c_id, dev_addr, i2c.TRANSMITTER)
    i2c.write(i2c_id,itime)
    i2c.stop(i2c_id)

    tmr.delay(100)
-- get msb
    i2c.start(i2c_id)
    i2c.address(i2c_id, dev_addr + 1, i2c.RECEIVER)
    msb = i2c.read(i2c_id, 1)
    i2c.stop(i2c_id)
--get lsb    
    i2c.start(i2c_id)
    i2c.address(i2c_id, dev_addr, i2c.RECEIVER)
    lsb = i2c.read(i2c_id, 1)
    i2c.stop(i2c_id)
    
    return 256 * string.byte(msb) + string.byte(lsb)
end

tmr.alarm(1, 2000, 1, function()
  uv = veml6070()
  print("UV steps: "..uv)
end)
