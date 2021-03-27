---
layout: post
title: In React, The Wrong Abstraction Kills Efficiency
---

As a software developer I like to think of myself as intelligent and discerning, but if I'm being completely honest with myself most of the decisions I make around code structure are governed by fairly low-resolution heuristics like 'Don't Repeat Yourself' and 'Keep It Simple, Stupid'. My stylistic intuitions all too often get priority over intuitions about long term maintenance and extensibility, in part because there are always arguments available that sound very serious and programmery but really just cover for the stylistic bias.

To illustrate what I'm talking about, let's start with a simple app that has a counter (original, I know) and some buttons to modify the counter.

![]({{ site.baseurl }}/images/posts/2020-2-6-React-Abstractions/1.png)

There's only really a couple of files here. Our App.js:

```jsx
// App.js
import React, { Component } from 'react';
import { createStore } from 'redux';
import { Provider } from 'react-redux';
import CounterSection from './CounterSection';
import './App.css';

function counter(state = 0, action) {
  switch (action.type) {
    case 'INCREMENT':
      return state + 1;
    case 'DECREMENT':
      return state - 1;
    case 'DOUBLE':
      return state * 2;
    case 'RESET':
      return 0;
    default:
      return state;
  }
}

let store = createStore(counter);

class App extends Component {
  render() {
    return (
      <Provider store={store}>
        <div className="App">
          <h1>Counter Culture, The #1 Counter App</h1>
          <CounterSection />
        </div>
      </Provider>
    );
  }
}

export default App;
```

And a `CounterSection` component to show the counter value and the available actions.

```jsx
// CounterSection.js
import React, { Component } from 'react';
import { useDispatch, useSelector } from 'react-redux';

const CounterSection = () => {
  const counter = useSelector(state => state);
  const dispatch = useDispatch();

  return (
    <div>
      <h1>{counter}</h1>
      <button
        className="counter-button"
        onClick={() => dispatch({ type: 'INCREMENT' })}
      >
        increment
      </button>
      <button
        className="counter-button"
        onClick={() => dispatch({ type: 'DECREMENT' })}
      >
        decrement
      </button>
      <button
        className="counter-button"
        onClick={() => dispatch({ type: 'DOUBLE' })}
      >
        double
      </button>
      <button
        className="counter-button"
        onClick={() => dispatch({ type: 'RESET' })}
      >
        reset
      </button>
    </div>
  );
};

export default CounterSection;
```

I know what you're thinking, this isn't very DRY. Firstly, we're using the same button element with the same class name four times, and we're doing basically the same thing in each onClick, except for the action type.

Time for a much cleaner `CounterSection`:

```jsx
// CounterSection.js
import React, { Component } from 'react';
import { useDispatch, useSelector } from 'react-redux';

const CounterButton = ({ children, actionType }) => {
  const dispatch = useDispatch();

  return (
    <button
      className="counter-button"
      onClick={() => dispatch({ type: actionType })}
    >
      {children}
    </button>
  );
};

const CounterSection = () => {
  const counter = useSelector(state => state);

  return (
    <div>
      <h1>{counter}</h1>
      <CounterButton actionType="INCREMENT">increment</CounterButton>
      <CounterButton actionType="DECREMENT">decrement</CounterButton>
      <CounterButton actionType="DOUBLE">double</CounterButton>
      <CounterButton actionType="RESET">reset</CounterButton>
    </div>
  );
};

export default CounterSection;
```

Much nicer! We've encapsulated the logic for modifying the counter inside the `CounterButton` component, meaning we no longer need a dispatch function in the `CounterSection` component, and we can leave it to simply rendering the counter and the available buttons.

A day passes, and a new requirement appears! We need a new button to `console.log` the current value of the counter to help with debugging. Alright, well we've already decided that we're going to encapsulate the counter-modification logic in that `CounterButton` component, so we'll need to make our change there.

Hmm...

we could do one of three things:

1. Add a new 'LOG' action and in the reducer simply do a console log with that action. Kinda weird because we're not actually modifying the state, but it would fit snuggly with our existing actionType prop on the CounterButton
2. Create a new button component for this one use case. That feels a little off to me: we're basically going to be duplicating the button element and button class, meaning if we change the class in one place we need to change it in the other place. Not DRY at all...
3. Add a new string prop to the CounterButton component for when you want to log something.

I think option 3 is the way to go here: not only will it solve the current use case, it can also be used by the other buttons in addition to their actions if we need to add per-action logging down the line! I imagine it would be cool to see a log message saying 'incrementing counter from value 0' when you click the increment button and the current value is zero.

Okay here's what we've got now:

```jsx
import React, { Component } from 'react';
import { useDispatch, useSelector } from 'react-redux';

const CounterButton = ({ children, actionType, log }) => {
  const dispatch = useDispatch();

  return (
    <button
      className="counter-button"
      onClick={() => {
        if (actionType) {
          dispatch({ type: actionType });
        }
        if (log) {
          console.log(log);
        }
      }}
    >
      {children}
    </button>
  );
};

const CounterSection = () => {
  const counter = useSelector(state => state);

  return (
    <div>
      <h1>{counter}</h1>
      <CounterButton actionType="INCREMENT">increment</CounterButton>
      <CounterButton actionType="DECREMENT">decrement</CounterButton>
      <CounterButton actionType="DOUBLE">double</CounterButton>
      <CounterButton actionType="RESET">reset</CounterButton>
      <CounterButton log={`current value: ${counter}`}>
        log current value
      </CounterButton>
    </div>
  );
};

export default CounterSection;
```

We happily dust off our hands, but then another requirement appears! We need to allow the user to type a number into an input and then press a button to add that number to our counter.

![]({{ site.baseurl }}/images/posts/2020-2-6-React-Abstractions/2.png)

This is an easy one. We'll add a metadata field on our action and then add an 'ADD' action to the reducer:

```jsx
function counter(state = 0, action) {
  switch (action.type) {
    case 'INCREMENT':
      return state + 1;
    case 'DECREMENT':
      return state - 1;
    case 'DOUBLE':
      return state * 2;
    case 'RESET':
      return 0;
    case 'ADD':
      return state + action.metadata.value;
    default:
      return state;
  }
}
```

As for our `CounterSection` component, we'll add an inputValue state variable and let that be controlled by the input, and then we can add an extra 'metadata' prop to `CounterButton` to take the value and give it to the action if it's present.

```jsx
// CounterSection.js
import React, { Component, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';

const CounterButton = ({ children, actionType, log, metadata }) => {
  const dispatch = useDispatch();

  return (
    <button
      className="counter-button"
      onClick={() => {
        if (actionType) {
          dispatch({
            type: actionType,
            ...(metadata && { metadata }),
          });
        }
        if (log) {
          console.log(log);
        }
      }}
    >
      {children}
    </button>
  );
};

const CounterSection = () => {
  const counter = useSelector(state => state);
  const [inputValue, setInputValue] = useState(0);

  return (
    <div>
      <h1>{counter}</h1>
      <CounterButton actionType="INCREMENT">increment</CounterButton>
      <CounterButton actionType="DECREMENT">decrement</CounterButton>
      <CounterButton actionType="DOUBLE">double</CounterButton>
      <CounterButton actionType="RESET">reset</CounterButton>
      <CounterButton log={`current value: ${counter}`}>
        log current value
      </CounterButton>
      <input
        onChange={event => setInputValue(parseInt(event.target.value))}
        value={inputValue}
      />
      <CounterButton actionType="ADD" metadata={{ value: inputValue }}>
        add
      </CounterButton>
    </div>
  );
};

export default CounterSection;
```

What can't this `CounterButton` do?! We have really hit the nail on the head in encapsulating this complex counter update logic and preventing our `CounterSection` from having to understand the implementation details.

Okay this is the part where I stop pretending that everything is okay. Everything is not okay. We started with a component that had some repeated code and we decided to make it as DRY as possible given the _current_ behaviour of the component, without considering what _future_ behaviour required.

We rightly factored out a button component, but bringing the dispatching code along for the ride was a big mistake.

We locked the code down in the form of an abstraction that only allowed the parent to express its intention via the use of string action type keys, meaning as soon as the parent needed behaviour that extended beyond the existing behaviour, we needed to move the complexity into our abstraction to live alongside the other code which was made for a completely different use case. Another programmer looking at the code in CounterButton would probably expect the `actionType` and `log` props to be related given they're right next to eachother in the component's body, but in fact they have nothing to do with eachtoher.

We knew this was true when we added the `log` prop, and so to defend our fragile ego and even more fragile abstraction we entertained a hypothetical future where we might want to both log _and_ dispatch an action, despite there being no known use case for it right _now_.

When we needed to pass more information to one of our actions, we had to express it in a way that would play nicely with the other use cases: by only conditionally adding a metadata key if the prop was present.

Worst of all, the knowledge of the available actions is _not_ actually hidden from the parent component, `CounterSection`, because it still needs to know what the type of the action is (and any metadata required) to pass down as a prop. For every new action we add to modify the counter in some way, we will need to make a change in the reducer, in `CounterSection`, and probably in CounterButton if the use case is once more slightly different to the ones that came before.

If we had acknowledged our initial screwup and bit the bullet, we might end up with something like this:

```jsx
import React, { Component, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';

const CounterButton = ({ children, onClick }) => (
  <button className="counter-button" onClick={onClick}>
    {children}
  </button>
);

const CounterSection = () => {
  const counter = useSelector(state => state);
  const dispatch = useDispatch();
  const [inputValue, setInputValue] = useState(0);

  return (
    <div>
      <h1>{counter}</h1>
      <CounterButton onClick={() => dispatch({ type: 'INCREMENT' })}>
        increment
      </CounterButton>
      <CounterButton onClick={() => dispatch({ type: 'DECREMENT' })}>
        decrement
      </CounterButton>
      <CounterButton onClick={() => dispatch({ type: 'DOUBLE' })}>
        double
      </CounterButton>
      <CounterButton onClick={() => dispatch({ type: 'RESET' })}>
        reset
      </CounterButton>
      <CounterButton onClick={() => console.log(`current value: ${counter}`)}>
        log current value
      </CounterButton>
      <input
        onChange={event => setInputValue(parseInt(event.target.value))}
        value={inputValue}
      />
      <CounterButton
        onClick={() =>
          dispatch({ type: 'ADD', metadata: { value: inputValue } })
        }
      >
        add
      </CounterButton>
    </div>
  );
};

export default CounterSection;
```

Now the CounterSection component is a little uglier to look at with all those onClick functions side by side, many being nearly identical, but it's leagues above the previous implementation. Now things that are side-by-side are related, and we don't need to try and weed out all the possible use cases that might or might not apply when looking at the code. When we need metadata, we use metadata. When we need to log, we log.

When you make the wrong abstraction and you start mixing a bunch of use cases together in the same block of code, you actually need to understand _all_ the use cases simultaneously to understand how a single use case will be treated and what code will actually apply.

When you make the wrong abstraction, you will start thinking up ways in which everything could fit together and make more sense down the line, just not right now.

When you make the wrong abstraction, you find yourself clinging to heuristics like DRY for dear life to justify the decision not to go and inline everything and start again.

The worst part about the wrong abstraction is that you can take it as far as you like. There is absolutely nothing functionally changing between the last two code snippets. The wrong abstraction will never break down. You on the other hand...

For the record, this isn't about presentational components vs containers. It just so happens that in this case, that heuristic would have been sufficient to stop us from falling into the trap. But this same delusional line of reasoning can creep in anywhere, even when there are no presentational elements directly involved.

If you find yourself making the same excuses to defend the wrong abstraction, just see what happens when you pull everything apart, widen the interface, and let the parent take care of the messy stuff. If there's any abstraction to be done, it's best to be done _after_ gaining deep familiarity with the scope of different behaviours required.

This revelation has been somewhat new to me, which is why I'm only now doing a writeup for it. But knowing that I am but a mere mortal developer full of bias and pride, I'm going to keep a new heuristic in my toolbelt this year:

WAKE: the Wrong Abstraction Kills Efficiency
