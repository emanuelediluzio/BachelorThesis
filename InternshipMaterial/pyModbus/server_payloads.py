#!/usr/bin/env python3
"""Pymodbus Server Payload Example.

This example shows how to initialize a server with a
complicated memory layout using builder.
"""
import asyncio

from server_async import run_async_server, setup_server
from pymodbus.datastore import (
    ModbusSequentialDataBlock,
    ModbusServerContext,
    ModbusSlaveContext,
)

def setup_payload_server(cmdline=None):

    datablock = ModbusSequentialDataBlock(5, [17] * 100)
    store = ModbusSlaveContext(di = datablock, co = datablock, hr = datablock, ir = datablock)
    context = ModbusServerContext(slaves=store, single=True)
    return setup_server(
        description="Run payload server.", cmdline=cmdline, context=context
    )
      
if __name__ == "__main__":
    run_args = setup_payload_server()
    asyncio.run(run_async_server(run_args))