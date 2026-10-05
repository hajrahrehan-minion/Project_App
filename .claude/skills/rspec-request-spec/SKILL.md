# Project Coding Skills

## RSpec Conventions

These conventions apply whenever creating, modifying, or reviewing RSpec tests in this Rails project.

### General

* Use `rails_helper` for Rails specs.
* Prefer behavior-focused tests over implementation-detail tests.
* Write the smallest test that proves the intended behavior.
* Use existing Rails fixtures and application behavior where appropriate.
* When adding or changing behavior, write the failing spec first, then make it pass.
* Run the relevant spec after changes, then run the full suite when appropriate.

### Model Specs

Use the model as the described subject:

```ruby
RSpec.describe Project, type: :model do
```

Organize behavior with `describe` blocks:

```ruby
describe "validations" do
  ...
end

describe "associations" do
  ...
end
```

Use `it` for one specific behavior.

Prefer behavior assertions:

```ruby
expect(project).not_to be_valid
expect(project.errors[:title]).to include("can't be blank")
```

Common matchers:

* `be_valid` / `not_to be_valid` — Active Record validation behavior.
* `eq` — equality.
* `include` — collection/string membership.
* `change(...).by(...)` — verifies a state change.

Do not test Rails implementation details unless the implementation itself is the behavior being tested.

### Request Specs

Request specs must use:

```ruby
RSpec.describe "Projects", type: :request do
```

Do **not** use:

```ruby
RSpec.describe Project, type: :model
```

for request specs.

Group endpoints by HTTP method and path:

```ruby
describe "GET /projects" do
  ...
end

describe "POST /projects" do
  ...
end
```

Use `context` when the expected behavior changes based on a meaningful condition:

```ruby
context "when signed in" do
  ...
end

context "when not signed in" do
  ...
end
```

### Authentication

This project uses Rails' generated authentication system.

Request specs should exercise authentication through the real session endpoint rather than calling controller-private authentication methods directly.

Use existing user fixtures:

```ruby
fixtures :users

let(:user) { users(:one) }
```

Authenticate through:

```ruby
post session_path, params: {
  email_address: user.email_address,
  password: "password"
}
```

Do **not** directly call:

```ruby
start_new_session_for(user)
```

or other controller-private authentication methods from request specs.

Test both authenticated and unauthenticated behavior when authentication protects an endpoint.

Authenticated requests should assert the expected successful response:

```ruby
expect(response).to have_http_status(:success)
```

Unauthenticated protected requests should assert the login redirect:

```ruby
expect(response).to redirect_to(new_session_path)
```

### POST / Create Specs

For create requests, verify both:

1. The database changes as expected.
2. The HTTP response is correct.

Use the `change` matcher:

```ruby
expect {
  post projects_path, params: valid_params
}.to change(Project, :count).by(1)
```

Then verify the redirect:

```ruby
expect(response).to redirect_to(project_path(Project.last))
```

Do not test only the response when persistence is part of the behavior.

### Test Data

Use `let` for reusable or lazily evaluated test data:

```ruby
let(:user) { users(:one) }

let(:valid_params) do
  { project: { title: "My Project" } }
end
```

Prefer descriptive names:

* `user`
* `project`
* `valid_params`
* `invalid_params`

Avoid duplicating the same test data across multiple examples.

### Test Structure

Prefer this structure:

```text
RSpec.describe
  describe behavior/endpoint
    context condition
      before setup
      it expected behavior
```

Use `before` for setup shared by multiple examples in the same context.

Do not put assertions inside `before`.

Keep each `it` focused on one behavior.

### HTTP Response Testing

Use RSpec/Rails matchers rather than inspecting raw response internals when possible.

Examples:

```ruby
expect(response).to have_http_status(:success)
```

```ruby
expect(response).to have_http_status(:redirect)
```

```ruby
expect(response).to redirect_to(new_session_path)
```

Do not parse an HTML response with `JSON.parse` unless the endpoint explicitly returns JSON.

### What to Avoid

* Do not use model spec metadata for request specs.
* Do not call private controller authentication methods from request specs.
* Do not invent a `sign_in` helper when the project does not provide one.
* Do not test private controller implementation details.
* Do not create unnecessary records for a test that does not need them.
* Do not invent custom matchers when standard RSpec matchers are sufficient.
* Do not parse HTML as JSON.
* Do not duplicate reusable test data unnecessarily.
* Do not add application code merely to make a spec easier to write.

### Review Checklist

Before considering a spec complete, verify:

* [ ] The spec type is correct.
* [ ] `describe` accurately identifies the behavior or endpoint.
* [ ] `context` is used when meaningful conditions change behavior.
* [ ] `it` describes one concrete behavior.
* [ ] Reusable setup uses `let`.
* [ ] Shared setup uses `before` appropriately.
* [ ] Authentication follows the real Rails session flow.
* [ ] Authenticated and unauthenticated behavior is tested where relevant.
* [ ] Create requests verify database changes.
* [ ] Create requests verify the expected response/redirect.
* [ ] Standard RSpec matchers are used.
* [ ] Tests focus on behavior rather than implementation details.
* [ ] The relevant spec passes.
* [ ] The full RSpec suite still passes when appropriate.
