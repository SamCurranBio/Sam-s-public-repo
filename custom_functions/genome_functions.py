# identifiers
# seq
# filler
# qualities - ASCII-encoded Q (quality)

def QtoPhred33(Q):
    return chr(Q+33)

def Phred33toQ(qual):
    return ord(qual)-33


def read_genome(filename):
    genome = ''
    with open(filename, 'r') as f:
        for line in f:
            if not line[0] == '>': #don't want the description
                genome += line.rstrip() #removes whitespace
    return genome


def read_fastq(filename):
    sequences = []
    qualities = []
    with open(filename,'r') as fh:
        while True: #while file is reading lines 
            fh.readline() #first line is descriptor
            seq = fh.readline().rstrip() # second is sequence
            fh.readline() #third is spaceholder
            qual = fh.readline().rstrip() #4th is quality 
            if len(seq)  == 0:
                break
            sequences.append(seq)
            qualities.append(qual)
    return sequences, qualities


def naive(p,t): #looks for pattern p in text
    occurences = []
    print ('testing')
    num_alignments = 0
    num_comparisons = 0
    for i in range(len(t)-len(p) + 1): # loop over all alignments
        num_alignments += 1
        match = True
        for j in range(len(p)): #loop over chars in pattern p 
            num_comparisons +=1
            if t[i+j] != p[j]: #if index in t isn't p
                match  = False
                break
        if match:
            occurences.append(i)
    print('number of alignments:', num_alignments)
    print('number of comparisons:', num_comparisons)
    return occurences 


#### boyer-moore

# t_i is the letter at position i
# j is the offset we are currently at in pattern

# T, P are the text and pattern
# i, j are the respective indices
# Ti and Pj are the characters at each index 

def bad_character(Ti,j,pattern): 
    next_offset = pattern.rfind(Ti,0,j) # looks in pattern for Ti, from j to j=0
    if next_offset > 0: #if the next Ti was found in P, shift number ip to that of char comparisons between 
        shift = j - next_offset
    else: #if not, shift remainder of p 
        shift = len(pattern) - len(pattern[j:])
    return(shift)


def good_suffix(j, pattern):
    suffix = pattern[j+1:]
    next_suffix_offset = pattern.rfind(suffix,0,j+1) # this returns -1
    if next_suffix_offset > 0:
        shift = j+1 - next_suffix_offset
    else:
        shift  = len(pattern) - 1
    print('the good suffix is:', suffix)
    return(shift)


def bm(P,T): #looks for pattern p in text
    occurences = []
    i = 0
    alignment_region = len(T)-len(P) + 1
    while i <  alignment_region: # perform alignments from left to right 
        #print('i=',i)
        print('\n')
        print('position(i) is:',i)
        match = True
        
        for j in list(range(len(P)))[::-1]: #loop over chars in pattern p
            #print(j)
            #print('j=',j)
            #print('t=', t[i+j], 'p=', p[j])
            if T[i+j] != P[j]: #if index in t isn't p
                print ('mismatch_location on text (i+j) =',i+j)
                match  = False
                #then apply the bad character rule 
                a = bad_character(T[i+j],j,P) 
                print('mismatch location on pattern j =' ,j)
                b = good_suffix(j,P)
                print('the bad character rule shifts',a, 'such that the next alignment will occur at Pi = ', i+a)
                print('the good suffix rule shifts', b, 'such that the next alignment will occur at Pi = ', i+b)
                skip = max([a,b])
                i+=skip-1 #this needs to be -1, because there is always a +1 added on the round, regardless of the match outcome 
                break
        print(match)
        if match:
            occurences.append(i)
        i+=1
    return occurences 






def hamming(p,t, mismatch_threshold): #looks for pattern p in text
    occurences = []
    for i in range(len(t)-len(p) + 1): # loop over all alignments
        #print(i)
        match = True
        mismatches = 0 
        for j in range(len(p)): #loop over chars in pattern p 
            if t[i+j] != p[j]: #if index in t isn't p
                mismatches +=1 
                if mismatches > mismatch_threshold:
                    match = False
                    break
        if match:
            occurences.append(i)
    return mismatches

p = 'cde'
t = 'abcdefgh'
mismatch_threshold = 3
hamming(p,t, mismatch_threshold)
    
#good_suffix(5,pattern)