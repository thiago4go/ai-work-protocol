# Template Quick Reference

```bash
make list  # See all templates
```

**⚠️ Important**: Templates are blueprints, not final plans. Always update with specific details after creation.

## Projects (What to build)

### Development
- **standard** → New features
- **refactor** → Code improvements  
- **bugfix** → Fix issues
- **integration** → Connect systems
- **optimization** → Performance
- **migration** → Move data/code

### UI/UX 
- **ui-design** → New interfaces
- **ux-improvement** → Better UX
- **component-library** → Reusable UI
- **responsive-design** → Multi-device

### Research
- **investigation** → Answer questions

## Tasks (How to do it)

### Planning
- **discovery** → Research first
- **wireframing** → Low-fi design

### Building  
- **implementation** → Code it
- **prototyping** → Interactive UI
- **poc** → Prove it works

### Testing
- **testing** → Unit/integration
- **user-testing** → Real users
- **visual-regression** → UI changes
- **accessibility-audit** → A11y check

### Analysis
- **debugging** → Find bugs
- **deep-analysis** → Complex issues
- **review** → Code review

### Documentation
- **documentation** → Docs
- **style-guide** → Design docs
- **automation** → Automate tasks

## Quick Decisions

**Building something new?**
```bash
make project template=standard title="Feature X"
make task template=discovery title="Research options"
```

**UI work?**
```bash
make project template=ui-design title="Dashboard"  
make task template=wireframing title="Layout ideas"
```

**Fixing bugs?**
```bash
make project template=bugfix title="Login error"
make task template=debugging title="Find cause"
```

## Project → Task Combinations

### Development Projects
- **standard** → discovery → implementation → testing
- **refactor** → deep-analysis → implementation → testing
- **bugfix** → debugging → implementation → testing
- **integration** → discovery → poc → implementation
- **optimization** → deep-analysis → implementation → testing
- **migration** → discovery → implementation → testing

### UI/UX Projects  
- **ui-design** → wireframing → prototyping → user-testing
- **ux-improvement** → user-testing → wireframing → implementation
- **component-library** → discovery → implementation → style-guide
- **responsive-design** → discovery → implementation → visual-regression

### Research Projects
- **investigation** → deep-analysis → documentation

## Pro Tips
- Templates are starting points - customize them!
- Start with discovery/wireframing
- Use 1-3 day task cycles
- Check RAG for similar work first
- Update templates with real details after creation