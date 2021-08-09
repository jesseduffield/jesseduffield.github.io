---
layout: post
title: 'Anti-pattern of the Day: Type Keys'
---

Say we have a function which creates a user, and handles some specific setup depending on whether that user is an admin or a customer:

```ts
const createUser = (attributes: UserAttributes, userType: 'admin' | 'customer'): User => {
  user = User.create(attributes)

  switch (userType) {
    case 'admin':
      setupAdmin(user)
    case 'customer':
      setupCustomer(user)
  }

  user.setupNotifications()

  return user
}

...
// in some other file
const createAdmin = (attributes: UserAttributes): User => {
  return createUser(attributes, 'admin')
}

...
// in yet another file
const createCustomer = (attributes: UserAttributes): User => {
  return createUser(attributes, 'customer')
}
```

What do you notice about the `userType` argument? There are four things to note:

1. its value is always known at compile time. We're not receiving it as an parameter from an HTTP request or a value from the database.
2. its expected to have one of a finite set of values i.e. it's basically an enum.
3. given that it's basically an enum, its actual string value is meaningless: it will never be written anywhere or compared to another variable's value
4. inside the function, the argument is only used in a switch-statement (if-statements count too) i.e. the value only affects the control flow of the function

When you have these four ingredients, you have a type key. Not 'type' as in static vs dynamic typing, but 'type' as in variant. It's called a type key because it suggests that your function really has different variants and you want to key-in to a specific variant to get the behaviour you want.

This is an anti-pattern because the only time you have different types is to satisfy different use cases, and different use cases always change at different rates. Maybe the setup process for admins hasn't changed in a year but the process for customers changes monthly. Whenever two pieces of code need to change for different reasons, or at different rates, you _must_ separate those pieces and minimise the dependencies between them. Otherwise, in order to understand how a customer is created, you need to wade through a bunch of irrelevant admin-related code, making any single use case impossible to understand without understanding all the others.

Let's refactor this into something cleaner:

## Step 1

Split the function and pull the type key argument into the function as a constant

```ts
const createAdmin = (attributes: UserAttributes): User => {
  const userType = 'admin';

  user = User.create(attributes);

  switch (userType) {
    case 'admin':
      setupAdmin(user);
    case 'customer':
      setupCustomer(user); // this code path is never reached
  }

  user.setupNotifications();

  return user;
};

const createCustomer = (attributes: UserAttributes): User => {
  const userType = 'customer';

  user = User.create(attributes);

  switch (userType) {
    case 'admin':
      setupAdmin(user); // this code path is never reached
    case 'customer':
      setupCustomer(user);
  }

  user.setupNotifications();

  return user;
};
```

## Step 2

Clean up, removing any dead code paths

```ts
const createAdmin = (attributes: UserAttributes): User => {
  user = User.create(attributes);

  setupAdmin(user);

  user.setupNotifications();

  return user;
};

const createCustomer = (attributes: UserAttributes): User => {
  user = User.create(attributes);

  setupCustomer(user);

  user.setupNotifications();

  return user;
};
```

## Step 3

Factor out any remaining overlapping code.

### When Order Doesn't Matter

You may find that certain operations are completely independent meaning you can shuffle the order of function calls. Let's say that in this case `setupNotifications()` can be called before `setupAdmin(user)` and `setupCustomer(user)`. Then we can group those together:

```ts
const createAdmin = (attributes: UserAttributes): User => {
  user = User.create(attributes);
  user.setupNotifications();

  setupAdmin(user);

  return user;
};

const createCustomer = (attributes: UserAttributes): User => {
  user = User.create(attributes);
  user.setupNotifications();

  setupCustomer(user);

  return user;
};
```

And then factor out:

```ts
// this function could be inlined if desired
const createAdmin = (attributes: UserAttributes): User => {
  user = createUserWithNotifications(attributes);

  setupAdmin(user);

  return user;
};

// this function could be inlined if desired
const createCustomer = (attributes: UserAttributes): User => {
  user = createUserWithNotifications(attributes);

  setupCustomer(user);

  return user;
};

const createUserWithNotifications = (attributes: UserAttributes): User => {
  user = User.create(attributes);
  user.setupNotifications();

  return user;
};
```

### When Order Does Matter

If the order _was_ important, we could pass the in-between code as a callback:

```ts
// this function could be inlined if desired
const createAdmin = (attributes: UserAttributes): User => {
  return createUser(attributes, setupAdmin);
};

// this function could be inlined if desired
const createCustomer = (attributes: UserAttributes): User => {
  return createUser(attributes, setupCustomer);
};

const createUser = (
  attributes: UserAttributes,
  onCreate: (user: User) => void
): User => {
  user = User.create(attributes);

  onCreate(user);

  user.setupNotifications();

  return user;
};
```

And we're done!

## Why Is This Solution Better?

Our type key has magically disappeared and we no longer need to maintain it anymore. But that's not the main reason we did this refactor. This is really about dependencies. Let's compare the dependencies before and after our refactor:

### Before:

![]({{ site.baseurl }}/images/posts/typekeys/before.png)

The red arrows represent a dependency from something _general_ to something _specific_. These dependencies lead to bloated abstractions that are impossible to decipher. The mini-dependency arrows flowing from our `userType` type key are shrunken to represent the fact that a change in e.g. `setupAdmin` or `setupCustomer` may not require a change to `userType`, but adding/removing a user type _will_.

The little people represent reasons for change: perhaps all the changes to the `setupAdmin` function originate from feature requests from staff, but `setupCustomer`'s changes all originate from the product team. Whatever it is, the reasons for change are different.

### After:

![]({{ site.baseurl }}/images/posts/typekeys/after.png)

Isn't this nicer? There are fewer arrows flying around thanks to having `userType` out of the picture, but the important thing is that our `createUser` function is not dependent on our specific use cases, meaning that when changing a use case or adding a new use case (e.g. adding a 'vendor' user type) we don't need to touch our `createUser` function. This is the basis of the Open-Close Principle: entities should be open for extention but closed for modification. This principle can _only_ be satisfied when specific entities depend on general entities, not the other way around.

## Conclusion

Get into the habit of spotting type keys and removing them. If you can think of an example where a type key is appropriate, I'd like to know!

Until next time.
