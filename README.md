# Rails billing

An attempt to isolate the various models, concerns and general logic for basic billing functionality in Rails. This does **not** cover integrations with online APIs eg Stripe.

Exploring the relationship between `line_item`, `invoice`, `payment`, `credit_note` and others. The general idea is that different models can become resources that have line_items, this is to avoid the need for an intermediary `bill` model.

Any styling or visual choices are incidental.

`clinic`, `consultation`, `act`, `act_item` and other models are present simply as they form part of the business logic that this code was initially extracted from.

### Todo
- [ ] Generate line_items attached to various resources
- [ ] Invoice one or many resource's line items, grouped by client (and clinic in our version)
- [ ] Allow part payment of a single invoice
- [ ] Pay one or multiple invoices with a single payment
- [ ] Apply a credit note to an invoice which "cancels" it, potentially creating a client_credit if already paid/part paid
- [ ] Allowing a client_credit to be used as a payment method if any remaining
- [ ] Mark an invoice as an error (create a credit note with reason)
- [ ] Make a quote