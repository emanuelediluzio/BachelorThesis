#!/usr/bin/env python3
"""Pymodbus Client Payload Example.

This example shows how to build a client with a
complicated memory layout using builder-


Works out of the box together with payload_server.py
"""
import asyncio
import random
import string
import time

from client_async import run_async_client, setup_async_client
from pymodbus.constants import Endian
from pymodbus.payload import BinaryPayloadBuilder, BinaryPayloadDecoder


def random_payload(payloads):
    length = random.randint(5, 15)
    random_string = ''.join(random.choices(string.ascii_lowercase, k=length))    
    if random.random() < 0.5: 
        random_payload = random.choice(payloads)
        return random_payload   
    return random_string

async def run_payload_calls(client):
    byte_endian = Endian.Big
    word_endian = Endian.Big
    slave = 1
    address = 5
    
    builder = BinaryPayloadBuilder()
    builder.add_string("\n")
    for i in range(200):
        builder = BinaryPayloadBuilder()
        builder.add_string("\n")
        counter = 0
        while counter < 8:

            payloads = [
                "CPU Usage: " + str(random.randint(0,100)) + "%",
                "Temperature: " + str(random.randint(0,100)) + "C",
                "Humidity: " + str(random.randint(0,100)) + "%",
                "Pressure: " + str(random.randint(0,100)) + "hPa",
                "Noise level: " + str(random.randint(0,100)) + "dB",
                "Air Quality Index: " + str(random.randint(0,100))  
            ]
            
            print("-" * 80)
            random_string = random_payload(payloads)
            builder.add_string(random_string)
            builder.add_string("\n")
            payload = builder.build()
            count = len(payload)
            print("")
            print("Count: ", count)
            result = await client.write_registers(address, payload, skip_encode=True)
            assert not result.isError()
            print("-" * 80)
            print("Result: ", result)
            print("")
            rr = await client.read_holding_registers(address, count, slave)
            assert not rr.isError() 
            print("-" * 80)
            print("-" * 32, "Newest Version", "-" * 32)
            print("-" * 80)
            print("Operation: ", rr)
            print("Registers: ", rr.registers)
            decoder2 = BinaryPayloadDecoder.fromRegisters(rr.registers, byteorder=byte_endian, wordorder=word_endian)
    
            decoded2 = decoder2.decode_string(500).decode()
            print(decoded2)
            counter += 1
        i+=1
        print(i)

if __name__ == "__main__":
    testclient = setup_async_client(description="Run payload client.")
    asyncio.run(run_async_client(testclient, modbus_calls=run_payload_calls))