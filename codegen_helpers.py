# -*- coding: utf-8 -*-

def genSingleEncode(spec, cValue, unresolved_domain):
    buffer = []
    type = spec.resolveDomain(unresolved_domain)
    if type == 'shortstr':
        buffer.append("pieces << %s.bytesize.chr" % (cValue,))
        buffer.append("pieces << %s" % (cValue,))
    elif type == 'longstr':
        buffer.append("pieces << [%s.bytesize].pack('N')" % (cValue,))
        buffer.append("pieces << %s" % (cValue,))
    elif type == 'octet':
        buffer.append("pieces << [%s].pack('c')" % (cValue,))
    elif type == 'short':
        buffer.append("pieces << [%s].pack('n')" % (cValue,))
    elif type == 'long':
        buffer.append("pieces << [%s].pack('N')" % (cValue,))
    elif type == 'longlong':
        buffer.append("raise NotImplementedError.new #pieces << [%s].pack('>Q')" % (cValue,)) # TODO: this is what's screwed-up in Ruby, we need a solution!
    elif type == 'timestamp':
        buffer.append("#raise NotImplementedError.new #pieces << [%s].pack('>Q')" % (cValue,)) # TODO: this is what's screwed-up in Ruby, we need a solution!
    elif type == 'bit':
        raise "Can't encode bit in genSingleEncode"
    elif type == 'table':
        buffer.append("pieces << AMQ::Protocol::Table.encode(%s)" % (cValue,))
    else:
        raise "Illegal domain in genSingleEncode", type

    return buffer

def genSingleDecode(spec, field):
    cLvalue = field.ruby_name
    unresolved_domain = field.domain

    if cLvalue == "known_hosts":
        import sys
        print >> sys.stderr, field, field.ignored

    type = spec.resolveDomain(unresolved_domain)
    buffer = []
    if type == 'shortstr':
        buffer.append("length = data[offset..(offset + 1)].unpack('c')[0]")
        buffer.append("offset += 1")
        buffer.append("%s = data[offset..(offset + length)]" % (cLvalue,))
        buffer.append("offset += length")
    elif type == 'longstr':
        buffer.append("length = data[offset..(offset + 4)].unpack('N').first")
        buffer.append("offset += 4")
        buffer.append("%s = data[offset..(offset + length)]" % (cLvalue,))
        buffer.append("offset += length")
    elif type == 'octet':
        buffer.append("%s = data[offset...(offset + 1)].unpack('c').first" % (cLvalue,))
        buffer.append("offset += 1")
    elif type == 'short':
        buffer.append("%s = data[offset..(offset + 2)].unpack('n').first" % (cLvalue,))
        buffer.append("offset += 2")
    elif type == 'long':
        buffer.append("%s = data[offset..(offset + 4)].unpack('N').first" % (cLvalue,))
        buffer.append("offset += 4")
    elif type == 'longlong':
        buffer.append("%s = data[offset..(offset + 8)].unpack('N2').first" % (cLvalue,))
        buffer.append("offset += 8")
    elif type == 'timestamp':
        buffer.append("%s = data[offset..(offset + 8)].unpack('N2').first" % (cLvalue,))
        buffer.append("offset += 8")
    elif type == 'bit':
        raise "Can't decode bit in genSingleDecode"
    elif type == 'table':
        buffer.append("table_length = Table.length(data[offset..(offset + 4)])")
        buffer.append("%s = Table.decode(data[offset..table_length])" % (cLvalue,))
    else:
        raise "Illegal domain in genSingleDecode", type

    return buffer

def genEncodeMethodDefinition(spec, m):
    def finishBits():
        if bit_index is not None:
            buffer.append("pieces << [bit_buffer].pack('c')")

    bit_index = None
    buffer = []

    for f in m.arguments:
        if spec.resolveDomain(f.domain) == 'bit':
            if bit_index is None:
                bit_index = 0
                buffer.append("bit_buffer = 0")
            if bit_index >= 8:
                finishBits()
                buffer.append("bit_buffer = 0")
                bit_index = 0
            buffer.append("bit_buffer = bit_buffer | (1 << %d) if %s" % (bit_index, f.ruby_name))
            bit_index = bit_index + 1
        else:
            finishBits()
            bit_index = None
            buffer += genSingleEncode(spec, f.ruby_name, f.domain)

    finishBits()
    return buffer

def genDecodeMethodDefinition(spec, m):
    buffer = []
    bitindex = None
    for f in m.arguments:
        if spec.resolveDomain(f.domain) == 'bit':
            if bitindex is None:
                bitindex = 0
            if bitindex >= 8:
                bitindex = 0
            if bitindex == 0:
                buffer.append("bit_buffer = data[offset..(offset + 1)].unpack('c').first")
                buffer.append("offset += 1")
                buffer.append("%s = (bit_buffer & (1 << %d)) != 0" % (f.ruby_name, bitindex))
                #### TODO: ADD bitindex TO THE buffer
            bitindex = bitindex + 1
        else:
            bitindex = None
            buffer += genSingleDecode(spec, f)
    return buffer
