# what if there's a fasta file that sequence on multiple lines?
seqs = {}
f =  open('myfile.txt', 'r')
for line in f: 
    line = line.rstrip()
    if line.startswith('>'):
        name = line 
        seqs[name] = '' 
    else:
        seqs[name] = seqs[name] + line #this will keep going until a new name is found, so should deal well with multi-line fastas

f.close()
seqs