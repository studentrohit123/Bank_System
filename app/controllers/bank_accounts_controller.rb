class BankAccountsController < ApplicationController
  def index
    @bank_accounts = BankAccount.all
  end

  def invest
    amount = params[:amount].to_i
    @result = process_investment(amount)
    @bank_accounts = BankAccount.all 
    render :index
  end

  private

  def process_investment(amount)
    accounts = BankAccount.all.map { |acc| { name: acc.name, balance: acc.balance - (acc.min_balance_enforced ? acc.min_balance.to_i : 0) } }
    accounts.sort_by! { |acc| acc[:balance] }
   
    collected = 0
    used_accounts = []

    accounts.each do |acc|
      next if acc[:balance] <= 0 

      if collected + acc[:balance] >= amount
        used_accounts << { name: acc[:name], deducted: amount - collected }
        return used_accounts
      else
        collected += acc[:balance]
        used_accounts << { name: acc[:name], deducted: acc[:balance] }
      end
    end

    collected < amount ? "NO MATCH" : used_accounts
  end
end
