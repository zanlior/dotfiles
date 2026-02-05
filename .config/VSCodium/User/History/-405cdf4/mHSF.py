import math
import sympy
import ollama

print('Welcome to the Everything Calculator™!')
print('--------------------------------------')

running=True
history= '' 

def enter_number():
    choice=int(input('''
    Pick an option:
        1. Enter a number
        2. pi
        3. e
    '''))
    if choice==1:
        num1= float(input("Enter a number: "))
    elif choice==2:
        num1=math.pi
    elif choice==3:
        num1=math.e
    else:
        print('Please provide a valid input.')
    return(num1)


def calc2op(num1,num2):
    global history
    op= int(input('''
    Please select an operation:
        1. addition
        2. subtraction
        3. multiplication
        4. division
        5. exponentiation
        6. yth root of x(x**(1/y))
        7. log x (base y)
    '''))
    if op==1:
        print(num1+num2)
        print('--------------------------------------')
        history+=(str(num1)+' + '+str(num2)+' = '+ str(num1+num2)+'\n')
    elif op==2:
        print(num1-num2)
        print('--------------------------------------')
        history+=(str(num1)+' - '+str(num2)+' = '+ str(num1-num2)+'\n')
    elif op==3:
        print(num1*num2)
        print('--------------------------------------')
        history+=(str(num1)+' * '+str(num2)+' = '+ str(num1*num2)+'\n')
    elif op ==4:
        if num2!=0:
            print(num1/num2)
            print('--------------------------------------')
            history+=(str(num1)+' / '+str(num2)+' = '+ str(num1/num2)+'\n')
        else:
            print('Please provide a valid input.')
            print('--------------------------------------')
    elif op==5:
        print(num1**num2)
        print('--------------------------------------')
        history+=(str(num1)+' ^ '+str(num2)+' = '+ str(num1**num2)+'\n')
    elif op==6:
        if num2!=0:
            print(num1**(1/num2))
            print('--------------------------------------')
            history+=(str(num2)+'th root of '+ str(num1)+' = '+str(num1**(1/num2))+'\n')
    elif op==7:
        if num1>0 and num2>0:
            if num2 != 1:
                print(math.log(num1, num2))
                print('--------------------------------------')
                history+=('log'+str(num1)+'(with base'+str(num2)+') = '+ str(math.log(num1,num2))+'\n')
            else:
                print('Please enter a valid input.')
                print('--------------------------------------')
        else:
            print('Please enter a valid input.')
            print('--------------------------------------')
    else:
        print('Please enter a valid input.')
        print('--------------------------------------')
    return history
          

def calc1op(num1):
    global history
    op= int(input('''
    Please select an operation:
        1. absolute value (modulus)
        2. trigonometric function(s)
        3. square root
        4. natural log(base e)
        5. common log(base 10)
        6. exponential function(e^x)
        7. factorial(n!)
        8. reciprocal(1/x)
        9. ceiling function
        10. greatest integer function
    '''))
    if op==1:
        print(abs(num1))
        print('--------------------------------------')
        history+=('abs('+str(num1)+')='+ str(abs(num1))+'\n')
    elif op==2:
        angle_type=int(input('''
    Is your angle in degrees or in radians?
        1. Degrees
        2. Radians
    '''))
        if angle_type==1:
            num1=num1*math.pi/180
        elif angle_type==2:
            num1=num1
        else:
            print('Please provide a valid input.')
            print('--------------------------------------')
        ratio=int(input('''
    Please select the ratio you wish to calculate:
        1. sin
        2. cos
        3. tan
        4. sec
        5. cosec
        6. cot
    '''))
        if ratio==1:
            print(math.sin(num1))
            print('--------------------------------------')
            history+=('sin'+ str(num1)+ ' = '+ str(math.sin(num1))+'\n')
        elif ratio==2:
            print(math.cos(num1))
            print('--------------------------------------')
            history+=('cos'+ str(num1)+ ' = '+ str(math.cos(num1))+'\n')
        elif ratio==3:
            print(math.tan(num1))
            print('--------------------------------------')
            history+=('tan'+ str(num1)+ ' = '+ str(math.tan(num1))+'\n')
        elif ratio==4 and (math.cos(num1)!=0):
            print(1/math.cos(num1))
            print('--------------------------------------')
            history+=('sec'+ str(num1)+ ' = '+ str(1/math.cos(num1))+'\n')
        elif ratio==5 and (math.sin(num1)!=0):
            print(1/math.sin(num1))
            print('--------------------------------------')
            history+=('cosec'+ str(num1)+ ' = '+ str(1/math.sin(num1))+'\n')
        elif ratio==6 and (math.tan(num1)!=0):
            print(1/math.tan(num1))
            print('--------------------------------------')
            history+=('cot'+ str(num1)+ ' = '+ str(1/math.tan(num1))+'\n')
        else:   
            print('Please provide a valid input.')
            print('--------------------------------------')
    elif op==3:
        if num1>=0:
            print(math.sqrt(num1))
            print('--------------------------------------')
            history+=('sqrt'+str(num1)+' = '+ str(math.sqrt(num1))+'\n')
        else:
            root=math.sqrt(abs(num1))
            print(str(root)+'i')
            print('--------------------------------------')
            history+=('sqrt'+str(num1)+' = '+ str(math.sqrt(abs(num1)))+'i \n')
    elif op ==4:
        if num1>0:
            print(math.log(num1))
            print('--------------------------------------')
            history+=('ln'+str(num1)+' = '+ str(math.log(num1))+'\n')
        else:
            print('Function not supported.')
            print('--------------------------------------')
    elif op==5:
        if num1>0:
            print(math.log10(num1)) 
            print('--------------------------------------')
            history+=('log'+str(num1)+' = '+str(math.log10(num1))+'\n')
        else:
            print('Function not supported.')
            print('--------------------------------------')
    elif op==6:
        print((math.e)**num1)
        print('--------------------------------------')
        history+=('e^'+str(num1)+' = '+ str((math.e)**num1)+'\n')
    elif op==7:
        if num1<0:
            print('Factorial does not exist for negative numbers.')
        elif num1==0:
            print('0!=1')
            print('--------------------------------------')
            history+='0!=1'
        elif num1-math.ceil(num1)==0:
            fact=1
            for i in range(1,int(num1)+1):
                fact*=i
            print(fact)
            print('--------------------------------------')
            history+=(str(int(num1))+'! = '+ str(fact)+'\n')
        else:
            print('Factorial does not exist for this number.')
    elif op==8:
        if num1 != 0:
            print(1/num1)
            print('--------------------------------------')
            history+= ('reciprocal of '+ str(num1) + ' = '+ str(1/num1)+'\n')
        else:
            print('Please provide a valid input.')
            print('--------------------------------------')
    elif op==9:
        print(math.ceil(num1))
        print('--------------------------------------')
        history+= ('ceiling function of '+ str(num1)+' = '+ str(math.ceil(num1))+'\n')
    elif op==10:
        print(num1//1)
        print('--------------------------------------')
        history+= ('greatest integer function of '+ str(num1)+' = '+ str(num1//1)+'\n')
    else:
        print('Please provide a valid input.')
        print('--------------------------------------')
    return(history)  


def algebra():
    while True:
        problem_type=int(input('''
    Please select the type of problem you wish to solve:
        1. Linear equation in one variable
        2. Quadratic equation in one variable
        3. Pair of linear equations in 2 variables
        4. Exit to main menu
    '''))
        if problem_type==1:
            a=float(input('Enter the coefficient of x: '))
            b= float(input('Enter the constant term(make sure the equation is in standard form): '))
            if a!=0:
                print('The solution is: ', -b/a)
                print('--------------------------------------')
        elif problem_type==2:
            a= float(input('Enter the coefficient of x^2: '))
            b= float(input('Enter the coefficient of x: '))
            c= float(input('Enter the constant term: '))
            if a!=0:
                D=b**2-4*a*c

                if D>0:
                    print('The roots are: ', (-b+D**0.5)/(2*a), (-b-D**0.5)/(2*a))
                    print('--------------------------------------')
                elif D==0:
                    print('The solution is: ', -b/(2*a))
                    print('--------------------------------------')
                else:
                    print('There are no real roots')
                    print('--------------------------------------')
        elif problem_type==3:
            a1=float(input('Enter the value of a1: '))
            b1=float(input('Enter the value of b1: '))
            c1=float(input('Enter the value of c1: '))
            a2=float(input('Enter the value of a2: '))
            b2=float(input('Enter the value of b2: '))
            c2=float(input('Enter the value of c2: '))
            if a2!=0 and b2!=0 and c2!=0:
                r1, r2, r3= a1/a2, b1/b2, c1/c2

                if r1 != r2:
                    y=(a2*c1-a1*c2)/(a1*b2-a2*b1)
                    x=-1*(b1*y+c1)/a1
                    print('The solution is:','('+str(x)+','+str(y)+')')
                    print('--------------------------------------')
                elif r1==r2 and r2 != r3:
                    print('There are no solutions')
                    print('--------------------------------------')
                elif r1==r2 and r2==r3:
                    print('The lines are coincident i.e., there are infinitely many solutions')
                    print('--------------------------------------')
        elif problem_type==4:
            print('Exiting to main menu...')
            print('--------------------------------------')
            break
        else:
            print('Please provide a valid input.')
            print('--------------------------------------')

def enter_function():
    terms= int(input('Enter the number of terms in your function: '))

    function=0
    x= sympy.symbols('x')

    if terms>0:
        choice=int(input('''
    Pick an option:
        1. Polynomial function
        2. Trigonometric function
        3. Exponential function
    '''))
            
        if choice==1:
            for i in range(terms):
                k=int(input('Enter the coefficient of x: '))
                n=int(input('Enter the power of x: '))
                function+= k*x**n

        elif choice==2:
            for i in range(terms):
                ratio=int(input('''Select the trigonometric ratio:
                                    1. sin
                                    2. cos
                                    3. tan
                                    4. cosec
                                    5. sec
                                    6. cot
                                    '''))
                if ratio==1:
                    function+= sympy.sin(x)
                elif ratio==2:
                    function+= sympy.cos(x)
                elif ratio==3:
                    function+= sympy.tan(x)
                elif ratio==4:
                    function+= 1/sympy.sin(x)
                elif ratio==5:
                    function+= 1/sympy.cos(x)
                elif ratio==6:
                    function+= 1/sympy.tan(x)
                else:
                    print('Please provide a valid input')
                    print('--------------------------------------')
        elif choice==3:
            for i in range(terms):
                power=int(input("Enter the power of 'x' to the power of which 'e' is raised: "))
                function+= sympy.exp(power*x)
        else:
            print('Please provide a valid input.')
            print('--------------------------------------')
    return(function)

def chat_with_study_buddy(prompt):
    response=ollama.chat(
        model='mistral',
        messages=[{'role':'user','content':prompt}]
    )

    return response


while running==True:
    action=int(input('''
    Please select the action you wish to perform:
        1. Arithmetic Calculator
        2. Calculus Calculator
        3. Algebra Calculator
        4. Smart Study Buddy
        5. View History
        6. Quit
    '''))
    if action==1:
        while True:
            number_of_operands= int(input('''
    Enter number of operands:
        1. One operand
        2. Two operands
        3. Exit to main menu
    '''))
            if number_of_operands==1:
                num1=enter_number()
            elif number_of_operands==2:
                print('Entering operand one.')
                print('--------------------------------------')
                num1=enter_number()
                print('Entering operand two.')
                print('--------------------------------------')
                num2=enter_number()
            elif number_of_operands==3:
                print('Exiting to Main Menu...')
                print('--------------------------------------')
                break
            else:
                print('Please provide a valid input.')
                print('--------------------------------------')

            if number_of_operands==2:
                history=calc2op(num1,num2)
            elif number_of_operands==1:
                history=calc1op(num1)
            else:
                print('Please provide a valid input.')
                print('--------------------------------------')
    elif action==6:
        print('Thank you for using this calculator!')
        print('--------------------------------------')
        break
    elif action==5:
        print(history)
        print('--------------------------------------')
    elif action==3:
        algebra()
    elif action==2:
        while True:
            x=sympy.symbols('x')
            function=enter_function()
            operation=int(input('''
    Pick an operation:
        1. Differentiation
        2. Integration
        3. Exit to main menu
    '''))
            if operation==2:
                integral=sympy.integrate(function,x)
                print(integral, '+C')
                print('--------------------------------------')
                history+='Integral of '+ str(function) + ' is '+str(integral)+'+C \n'
            elif operation==1:
                derivative=sympy.diff(function, x)
                print(derivative)
                print('--------------------------------------')
                history+='Derivative of '+ str(function) + ' is '+str(derivative)+'\n'
            elif operation==3:
                print('Exiting to main menu...')
                print('--------------------------------------')
                break
            else:
                print('Please provide a valid input.')
                print('--------------------------------------')
    elif action==4:
        print('Welcome to Study Buddy!')
        print('Please keep your questions short and crisp for the best experience!')
        print('To exit to Main Menu, type EXIT.')
        history+='----------Opened Study Buddy----------'
        while True:
            question=input('You: ')
            if question.lower() in ['exit','bye','quit','break']:
                print('Exiting to Main Menu...')
                history+='----------Closed Study Buddy----------'
                break
            
            answer=chat_with_study_buddy(question+'answer in brief.')
            print('Study Buddy:',answer)

            history+=('You:'+question+'\n')
            history+=('Study Buddy: '+str(answer)+'\n')
            

    else:
        print('Please provide a valid input')
        print('--------------------------------------')