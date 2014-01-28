# Debitcredit

[![Build Status](https://travis-ci.org/vitaly/debitcredit.png)](https://travis-ci.org/vitaly/debitcredit)
[![Code Climate](https://codeclimate.com/github/vitaly/debitcredit.png)](https://codeclimate.com/github/vitaly/debitcredit)

Double Entry Accounting for Rails Applications

## Account Types, Debits and Credits

<http://en.wikipedia.org/wiki/Debits_and_credits>

In Double Entry Accounting there are 5 account types: Asset, Liability, Income,
Expense and Equity.

In each transaction, sources are credited and destinations are debited.

I repeat: credit is the **source** and debit is the **destination**.

debit and credit affect balance of an account differently depending on the
account type.

For Asset and Expense accounts, Debit increases the balance, and credit
decreases it. For the rest of the accounts it is the opposite. i.e. debit
decreases and credit increases the balance.

## Accounting Equation

At any given point accounts should satisfy the following equation:

    Assets + Expenses = Liabilities + Equity + Income

You can verify it with `Account.balanced?`.

Debitcredit takes care to keep the system balanced at all times, if you get an
unbalanced state, its a bug, please report immediately!

## Accounts

The 5 types of accounts are represented by `Debitcredit::AssetAccount`,
`Debitcredit::LiabilityAccount`, `Debitcredit::IncomeAccount`, `Debitcredit::ExpenseAccount` and `Debitcredit::EquityAccount`

You can create standalone accounts:

    Debitcredit::AssetAccount.create name: 'asset'
    puts Debitcredit::Account[:asset].name

Or you can have a reference for the account:

    Debitcredit::AssetAccount.create name: 'asset', reference: User.first

Or

    class User
      has_many :accounts, as: :reference, class_name: 'Debitcredit::Account'
      ...
    end

    User.first.accounts.asset.create name: 'bank'
    puts User.first.accounts[:bank].name

You can pass `overdraft_enabled: true` to prevent account from ever having a
negative balance.

## Transactions

You can prepare transactions using DSL:

    t = Transaction.prepare(description: 'rent payment') do
      debit expense_account, 100, "you can also provide a comment"
      credit bank_account, 50
      credit creditcard, 50
    end
    t.save!

Sum of the debits must be equal to the sum of the credits. Amounts can not be
negative.

You can create transactions with a reference. For this case, and in case that
reference has 'accounts' association, you can use account names instead of objects:

    t = user1.transactions.prepare(description: 'sale') do
      debit :checking, 100 # will use user1.accounts[:checking]
      credit user2.accounts[:checking], 100
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# License

This project rocks and uses MIT-LICENSE.