q = 0x40000000000000000000000000000000224698fc0994a8dd8c46eb2100000001
K = GF(q)
P.<X> = K[]

#def roots_of_unity(n):
#    z = X^n - 1
#    return z.roots()

# Generates a table from a parsed expr tree
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
    a =  [row[0] for row in table]
    b =  [row[1] for row in table]
    c =  [row[2] for row in table]
    ql = [row[3] for row in table]
    qr = [row[4] for row in table]
    qo = [row[5] for row in table]
    qm = [row[6] for row in table]
    qc = [row[7] for row in table]

    Ql = P.lagrange_polynomial((omega^i, ql_i) for i, ql_i in enumerate(ql))
    Qr = P.lagrange_polynomial((omega^i, ql_r) for i, ql_i in enumerate(qr))
    Qo = P.lagrange_polynomial((omega^i, ql_o) for i, ql_i in enumerate(qo))
    Qm = P.lagrange_polynomial((omega^i, ql_m) for i, ql_i in enumerate(qm))
    Qc = P.lagrange_polynomial((omega^i, ql_c) for i, ql_i in enumerate(qc))

    print(Ql)


if __name__ == '__main__':
    ast = ('+', ('*', 5, 6), 2)
    table = to_table(ast)
    print(table)
    Z_H = X^(2^32)-1
    print(type(Z_H))
    #preprocess(table)
