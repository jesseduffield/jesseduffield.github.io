---
layout: post
title: Ranking the Four Approaches to Compound Components, from Worst to Best
image: ''
---

Say we wanted to create an Accordion component that lets us expand and collapse sections within the Accordion, such that only one section can be expanded at a time. This is a good candidate for a Compound Component. Let's first create an Accordion with three sections, without trying to abstract out any logic.

<!-- wp:html -->
<html>
<iframe src="https://codesandbox.io/embed/Accordion-1-jthu2?fontsize=14&hidenavigation=1&theme=dark"
     style="width:100%; height:500px; border:0; border-radius: 4px; overflow:hidden;"
     title="Accordion-1"
     allow="accelerometer; ambient-light-sensor; camera; encrypted-media; geolocation; gyroscope; hid; microphone; midi; payment; usb; vr; xr-spatial-tracking"
     sandbox="allow-forms allow-modals allow-popups allow-presentation allow-same-origin allow-scripts"
></iframe>
</html>
<!-- /wp:html -->

This does the job well, but we're combining Accordion-specific logic with the actual content we want to render. How might we abstract out the Accordion component from here? There are four ways. Let's go through each one, grading them based on type safety, aesthetics, encapsulation, and explicitness.

## Render Prop

<!-- wp:html -->
<html>
<iframe src="https://codesandbox.io/embed/Accordion-render-props-3lbfm?fontsize=14&hidenavigation=1&theme=dark"
     style="width:100%; height:500px; border:0; border-radius: 4px; overflow:hidden;"
     title="Accordion-render-props"
     allow="accelerometer; ambient-light-sensor; camera; encrypted-media; geolocation; gyroscope; hid; microphone; midi; payment; usb; vr; xr-spatial-tracking"
     sandbox="allow-forms allow-modals allow-popups allow-presentation allow-same-origin allow-scripts"
   ></iframe>
</html>
<!-- /wp:html -->

Here we're exposing the `isActive` and `onToggle` props through the render prop to be threaded through to each AccordionSection at the call site. It's the client's job to assign an index to each child.

### Type safety

Fairly type safe: no hoop-jumping required. One shortcoming is that we can't enforce the render prop function to return AccordionSection elements. We can get close by typing it as `React.ReactElement<AccordianSectionProps>` but then we wouldn't be able to return a fragment, we'd have to return an actual array of JSX. And we care less about the props and more about the actual element type. Alas, typescript can't help us here.

### Aesthetics

Ugly as hell: it's hard to discern between the boilerplate and the props that matter.

### Encapsulation

Non-existant: the client code is forced not only to know about the internal logic of how the component works, it's forced to _implement_ the internal logic, by threading through props to each section and keeping track of indexes. This is problematic for two reasons: firstly, it creates a dependency on the internal logic, meaning if we want to change the internal logic (e.g. to allow multiple sections to be expanded simultaneously) we'll need to update all the call sites. Secondly, because we're implementing the boilerplate logic at each call site, there's an increased chance of bugs: nothing stops us from accidentally assigning indexes incorrectly.

### Explicitness

You might argue this is more explicit than other approaches, and I would only partially agree. There's no 'magic' happening in the Accordion component itself, but it's not at all explicit how you should hook everything up at the call site. It's not obvious from looking at the Accordion component itself that it's your job to thead the props through via the render prop; you'll need to look at a couple examples to realise the pattern.

### Grade

**F**. The encapsulation issue is a deal-breaker for me.

## cloneElement

<!-- wp:html -->
<html>
<iframe src="https://codesandbox.io/embed/Accordion-clone-element-eu493?fontsize=14&hidenavigation=1&theme=dark"
     style="width:100%; height:500px; border:0; border-radius: 4px; overflow:hidden;"
     title="Accordion-clone-element"
     allow="accelerometer; ambient-light-sensor; camera; encrypted-media; geolocation; gyroscope; hid; microphone; midi; payment; usb; vr; xr-spatial-tracking"
     sandbox="allow-forms allow-modals allow-popups allow-presentation allow-same-origin allow-scripts"
   ></iframe>
</html>
<!-- /wp:html -->

Here we omit the `active` and `onToggle` props at the call site, and instead clone the element with the props added within the Accordion component.

### Type safety

Not type safe: we don't know the value of the `active` or `onToggle` props at the call site: they only get passed from inside the Accordion component. That means we need to make the `active` and `onToggle` props on the AccordionSection optional, and add a runtime check at the top of the component to ensure the props have actually been passed. So if you get this wrong, you'll only know at runtime! There's also nothing stopping the client from passing the `active` or `onToggle` to the AccordionSection, despite the fact that those props are meaningless at the call site. As you type out the props, your editor will suggest to pass `active` or `onToggle` which cause confusion.

### Aesthetics

Looks good from the call site, which is the place that matters the most. Using JSX components without the boilerplate of a render prop tells the reader how this will end up looking in the DOM at a glance, which is both expressive and pleasing to the eye.

### Encapsulation

Well-encapsulated: the call site has no knowledge of the internal logic so we can change that logic without having to update any call sites.

### Explicitness

Not great: there is some coordination happening between the parent and child, and all that magic lives in the parent. And, as stated above, it's not obvious that you shouldn't pass the `active` and `onToggle` props at the call site. If cloneElement allowed us to take an input element and return a different element, we could get around the typing issue by omitting those two props from the input element's type, but even then the structure isn't very explicit: we're passing in a JSX element which will never even get rendered? That begs the question why we're using JSX at all.

### Grade

**C**. Better than the render prop approach, but type safety and expressiveness are lacking.

## Context

<!-- wp:html -->
<html>
<iframe src="https://codesandbox.io/embed/accordian-context-dnj95?fontsize=14&hidenavigation=1&theme=dark"
     style="width:100%; height:500px; border:0; border-radius: 4px; overflow:hidden;"
     title="accordian-context"
     allow="accelerometer; ambient-light-sensor; camera; encrypted-media; geolocation; gyroscope; hid; microphone; midi; payment; usb; vr; xr-spatial-tracking"
     sandbox="allow-forms allow-modals allow-popups allow-presentation allow-same-origin allow-scripts"
   ></iframe>
</html>
<!-- /wp:html -->

Here we create a provider per child, passing the `active` and `onToggle` props. Those props no longer exist in the AccordionSection's props interface.

### Type safety

Fairly type safe: now that we've accessing our `active` and `onToggle` props via a Context, we no longer need to expose them in the AccordionSection's props, meaning the client can't accidentally pass values for those props. As with the previous options, we can't enforce that the right children are passed beyond specifying the props interface of each element (I've omitted this from the solution for simplicity).

### Aesthetics

Same as cloneElement: looks good from the call site.

### Encapsulation

Well-encapsulated: call site has no idea about the external logic.

### Explicitness

More explicit than the cloneElement approach: you can look at either Accordion or AccordionSection component to see the coordination happening between them, whereas with cloneElement you have no idea just by looking at AccordionSection because all the magic lives in Accordion.

### Grade

**A**. A step-up from cloneElement that patches the type issues and has a more discoverable implementation.

## POJOs

<!-- wp:html -->
<html>
<iframe src="https://codesandbox.io/embed/accordian-config-kz42b?fontsize=14&hidenavigation=1&theme=dark"
     style="width:100%; height:500px; border:0; border-radius: 4px; overflow:hidden;"
     title="accordian-config"
     allow="accelerometer; ambient-light-sensor; camera; encrypted-media; geolocation; gyroscope; hid; microphone; midi; payment; usb; vr; xr-spatial-tracking"
     sandbox="allow-forms allow-modals allow-popups allow-presentation allow-same-origin allow-scripts"
   ></iframe>
</html>
<!-- /wp:html -->

Here instead of passing JSX children to Accordion, we pass plain old javascript objects (POJOs). This technically means that we're no longer actually creating a compound component, but the end result is the same in terms of behaviour.

### Type safety

100% type safe. Now that AccordianSection is an interface rather than a component, we have complete control over it. It is not possible to pass the wrong children to Accordion because Accordion no longer takes children.

### Aesthetics

Pretty ugly: if each section contains a big blob of JSX, that will not look great with our structure.

### Encapsulation

Well-encapsulated for the same reason as the others.

### Explicitness

Fairly explicit. The only thing lacking is that it's not clear on the call site how our accordian sections will be handled. The default assumption is that they'll be converted to JSX inside Accordion, but it's not communicated in the interface. Where the cloneElement and Context approaches misinform the reader (coordination between Accordion and AccordionSection not obvious from call site), the POJO approach avoids the assumptions that come with JSX, meaning there's less risk of confusion.

### Grade

**A+**. Strong type safety, highly expressive, and minimises the chance of confusion. Only real downside is the aesthetic factor and that's the least important factor.

## Conclusion

It ends up being a close contest between using Context and using POJOs. In the case of an accordion, the POJO approach wins, but in other cases I can see Context winning e.g. when we want more flexibility around which children can be passed (e.g. sprinkling your own random elements among the children that the component doesn't know or care about). The Render Prop pattern works well when we expect the client to do something unique with the render prop's args, but when the client is just handling the coordination logic itself by threading through boilerplate props, it's not a great fit. React.cloneElement is better than the Render Prop approach, but still pretty average, specifically when you take the type safety into consideration.

What do you think? Have I failed to consider something in these ratings? Let me know!

---

## Addendum:

I'm pretty cautious about substituting JSX for POJOs in general, seeing how they've caused issues in the past when it made more sense to pass direct JSX. They happen to be the right fit for an accordion, but like all abstractions, you need to use them with care. If you see yourself needing to add additional JSX between the children of your compound component (e.g. help buttons, tooltips, separators) and don't want your compound component being dependent on those, switching to JSX may be the better approach. Note however that if you do that, you'll still need a way to distinguish between those children and the expected children. This can be done using a single Context provider that supplies (in this case) the `isActive` and `onToggle` functions and using the titles of accordion sections as keys rather than their indexes.
