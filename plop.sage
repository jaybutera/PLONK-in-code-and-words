# Generates a R1CS table from a parsed expr tree
def to_table(node):
    # Tuples of (a, b, c, q_l, q_r, q_o, q_m, q_c)
    table = []

    if type(t := node) == tuple:
        (op, a, b) = t
        # Recurse
        if ta := to_table(a):
            table += ta
        if tb := to_table(b):
            table += tb

        # Add top level
        if op == '+':
                a = evaluate(a)
                b = evaluate(b)
                table.append((a,b,a+b,1,1,1,0,0))
        if op == '*':
                a = evaluate(a)
                b = evaluate(b)
                table.append((a,b,a*b,0,0,1,1,0))

    return table

def evaluate(node):
    if type(t := node) == tuple:
        (op, a, b) = t
        if op == '+': return a+b
        if op == '*': return a*b
    return node

# Generate the q and permutation polynomials in the preprocess step
def preprocess(table):
    ql = [row[3] for row in table]
    qr = [row[4] for row in table]
    qo = [row[5] for row in table]
    qm = [row[6] for row in table]
    qc = [row[7] for row in table]


if __name__ == '__main__':
    ast = ('+', ('*', 5, 6), 2)
    print(to_table(ast))
