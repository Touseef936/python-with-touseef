class Bankaccount:
    def __init__(self):
        self.balance= 0

    def Deposite(self,deposite_amount):
        self.balance+=deposite_amount
        print(f"Deposite: {deposite_amount}")
        print(f"Current_balancen:{self.balance}")


    def Withdraw(self,withdraw_amount):
        self.balance-= withdraw_amount 
        print(f"Withdraw: {withdraw_amount}" )
        print(f"Current_balance:{self.balance}")
     
if __name__ == "__main__":
    system = Bankaccount()  
    a=int(input("Enter the 1.deposite 2.withdraw  "))
    while True:
        a=int(input("Enter the 1.deposite 2.withdraw  "))
        if a==1:
              deposite_amount=int(input("Enter deposite _amount:"))
              system.Deposite(deposite_amount)
        elif a==2:
              withdraw_amount=int(input("Enter withdraw _amount:"))
              system.Withdraw(withdraw_amount)
    
      
    
        
