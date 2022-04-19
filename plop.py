import sys
#import sage

# Generates a R1CS table from a parsed expr tree
def to_table(node):
    # Tuples of (a, b, c, q_l, q_r, q_o, q_m, q_c)
    table = []

    match node:
        case (_, a, b):
            # Recurse
            if ta := to_table(a):
                table += ta
            if tb := to_table(b):
                table += tb

    # Add top level
    match node:
        case ('+', a, b):
            a = evaluate(a)
            b = evaluate(b)
            table.append((a,b,a+b,1,1,1,0,0))
        case ('*', a, b):
            a = evaluate(a)
            b = evaluate(b)
            table.append((a,b,a*b,0,0,1,1,0))

    return table

def evaluate(node):
    match node:
        case ('+', a, b): return a+b
        case ('*', a, b): return a*b
        case _: return node


if __name__ == '__main__':
    ast = ('+', ('*', 5, 6), 2)
    print(to_table(ast))
