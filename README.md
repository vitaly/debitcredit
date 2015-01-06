# Debitcredit

[![Build Status](https://travis-ci.org/vitaly/debitcredit.png)](https://travis-ci.org/vitaly/debitcredit)
[![Code Climate](https://codeclimate.com/github/vitaly/debitcredit.png)](https://codeclimate.com/github/vitaly/debitcredit)

Double Entry Accounting for Rails Applications

## Installation

* add `gem 'debitcredit'` to your `Gemfile`
* and run `bundle install`
* run `rake debitcredit:install:migrations db:migrate db:test:prepare`

## Upgrade

* and run `bundle update debitcredit`
* run `rake debitcredit:install:migrations db:migrate`

### IMPORTANT: version 0.2.0 introduced backwards incompatible changes:

Transactions were renamed to entries. You need to rename:

* Transaction to Entry
* transactions to entries
* has_transactions to has_entries

## Account Types, Debits and Credits

<http://en.wikipedia.org/wiki/Debits_and_credits>

In Double Entry Accounting there are 5 account types: Asset, Liability, Income,
Expense and Equity defined as follows:

**Asset** is a resource controlled by the entity as a result of past events and
from which future economic benefits are expected to flow to the entity

**Liability** is defined as an obligation of an entity arising from past
entries or events, the settlement of which may result in the transfer or
use of assets, provision of services or other yielding of economic benefits in
the future.

**Income** is increases in economic benefits during the accounting period in
the form of inflows or enhancements of assets or decreases of liabilities that
result in increases in equity, other than those relating to contributions from
equity participants.

**Expense** is a decrease in economic benefits during the accounting period in
the form of outflows or depletions of assets or incurrences of liabilities that
result in decreases in equity, other than those relating to distributions to
equity participants.

**Equity** consists of the net assets of an entity. Net assets is the
difference between the total assets of the entity and all its liabilities.


In each entry, sources are credited and destinations are debited.

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

Or better yet:

    class User
      include Debitcredit::Extension

      has_accounts
      has_entries do
        def pay!
          ...
        end
      end
    end

By default accounts are prevented from having a negative balance, but you can
pass `overdraft_enabled: false` to allow it:

    Debitcredit::AssetAccount.create ..., overdraft_enabled: true

You can pass a block to `has_accounts` and to define referenced accounts:

    class User
      include Debitcredit::Extension

      has_accounts do
        income :salary
        expense :rent
        asset :checking, true # allow negative balance
      end
    end

    User.first.accounts.salary # will be created on first use

## Entries

You can prepare entries using DSL:

    t = Entry.prepare(description: 'rent payment') do
      debit expense_account, 100, "you can also provide a comment"
      credit bank_account, 50
      credit creditcard, 50
    end
    t.save!

Sum of the debits must be equal to the sum of the credits. Amounts can not be
negative.

You can create entries with a reference. For this case, and in case that
reference has 'accounts' association, you can use account names instead of objects:

    t = user1.entries.prepare(description: 'sale') do
      debit :checking, 100 # will use user1.accounts[:checking]
      credit user2.accounts[:checking], 100
    end

You can prepare an inverse entry. For example if you want to rollback an
existing entry:

rollback = existing.inverse(kind: 'refund', description: 'item is out of stock')
rollback.save!

> Note: by inverse entries are allowed to take accounts into overdraft. if
> this is undesirable, pass `enable_overdraft` to the `inverse` call.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# License

This project rocks and uses MIT-LICENSE.