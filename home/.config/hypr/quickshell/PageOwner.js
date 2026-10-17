.pragma library

function transition(owner, source, page) {
    if (page) return {owner: source, page: page};
    if (owner === source) return {owner: '', page: ''};
    return null;
}
