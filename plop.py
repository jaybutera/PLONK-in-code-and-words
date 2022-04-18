import sys

# Generates a CR1S table from a parsed expr tree
def table(node):
    # Tuples of (q_l, q_r, q_o, q_m, q_c)
    q_table = []
    # [(a,b,c)]
    abc = []

    match node:
        case (_, a, b):
            # Recurse
            if ta := table(a):
                q_table += ta[0]
                abc += ta[1]
            if tb := table(b):
                q_table += tb[0]
                abc += tb[1]

    # Add top level
    match node:
        case ('+', a, b):
            a = evaluate(a)
            b = evaluate(b)
            q_table.append((1,1,1,0,0))
            abc.append((a,b,a+b))
        case ('*', a, b):
            a = evaluate(a)
            b = evaluate(b)
            q_table.append((0,0,1,1,0))
            abc.append((a,b,a*b))

    return (q_table, abc)

def evaluate(node):
    match node:
        case ('+', a, b): return a+b
        case ('*', a, b): return a*b
        case _: return node


if __name__ == '__main__':
    ast = ('+', ('*', 5, 6), 2)
    print(table(ast))
