
# React içinde Custom Confirm nasıl yapılır
Aslında `window.prompt` değil, `window.confirm` gibi çalışıyor. İsimleri karıştırmışım :D
```JSX

import React, { useLayoutEffect, useState } from 'react'
import ReactDOM from 'react-dom'
import { Card } from '../card';
import useOnclickOutside from "react-cool-onclickoutside";
import { useTranslation } from 'react-i18next';
import cn from 'classnames';
import styles from './style.module.css';

const CustomPrompt = ({
    header,
    contentText,
    onClose,
    cancelOnClickOutside = true,
    acceptButtonText,
    cancelButtonText,
}) => {
    const { t } = useTranslation();
    const [opacityState, setOpacityState] = useState(false);
    useLayoutEffect(() => {
        setTimeout(() => setOpacityState(true), 50);
    }, [])
    const startClosing = (state) => {
        setOpacityState(false);
        setTimeout(() => {
            onClose(state);
        }, 300)
    }
    const ref = useOnclickOutside(() => {
        if (cancelOnClickOutside) {
            startClosing(false);
        }
    });
    const cancelText = cancelButtonText || t('text.cancel');
    const acceptText = acceptButtonText || t('text.ok');

    return (
        <div className={cn(styles.backDrop, { [styles.visible]: opacityState })}>
            <Card ref={ref} className={cn(styles.cardContent, { [styles.visible]: opacityState })}>
                {header && <div className={styles.header}>{header}</div>}
                <div>{contentText}</div>
                <div className={styles.footer}>
                    <button className='btn-secondary' onClick={() => startClosing(false)}>{cancelText}</button>
                    <button onClick={() => startClosing(true)}>{acceptText}</button>
                </div>
            </Card>
        </div>
    )
}

// Burası daha güzel olabilirdi galiba.
// 2. parametreye sadece bir property eklersek bug olabilir. 
/**
 * {header: "FOO"} diye gönderdik de. returnPromiseOnly falsy gelebilir..
 */
export const createPrompt = (contentText, {
    cancelOnClickOutside = true,
    header = null,
    acceptButtonText = null,
    cancelButtonText = null,
    returnPromiseOnly = true,
} = {}) => {

    let promiseResolveFunction = null;

    const promptContainer = document.createElement("div");
    promptContainer.classList.add("prompt-container");
    document.body.appendChild(promptContainer);

    const destroyPrompt = () => {
        ReactDOM.unmountComponentAtNode(promptContainer);
        document.body.removeChild(promptContainer);
    }


    const onCloseFunction = (confirmed) => {
        promiseResolveFunction(confirmed);
        destroyPrompt();
    }
    ReactDOM.render(
        <CustomPrompt
            onClose={onCloseFunction}
            header={header}
            contentText={contentText}
            cancelOnClickOutside={cancelOnClickOutside}
            acceptButtonText={acceptButtonText}
            cancelButtonText={cancelButtonText}
        />,
        promptContainer
    );
    const promise = new Promise((resolve) => {
        promiseResolveFunction = resolve;
    })
    if (returnPromiseOnly) {
        return promise;
    }
    return {
        destroyPrompt,
        promise
    }
};
```

