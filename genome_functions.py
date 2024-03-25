# identifiers
# seq
# filler
# qualities - ASCII-encoded Q (quality)

def QtoPhred33(Q):
    return chr(Q+33)

def Phred33toQ(qual):
    return ord(qual)-33