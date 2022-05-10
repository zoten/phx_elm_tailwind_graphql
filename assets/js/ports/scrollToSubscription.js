const subscription = (verticalOffset) => {
    window.requestAnimationFrame(() => {
        const main = document.querySelector('.main');

        if (main !== null) {
            main.scrollTo(0, verticalOffset);
        }
    });
};

export default subscription;
