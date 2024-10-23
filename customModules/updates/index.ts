import options from 'options';
import { module } from '../module';

import { inputHandler } from 'customModules/utils';
import Button from 'types/widgets/button';
import { Variable as VariableType } from 'types/variable';
import { pollVariableBash } from 'customModules/PollVar';
import { Attribute, Child } from 'lib/types/widget';
import { BarBoxChild } from 'lib/types/bar';

const {
    updateCommand,
    label,
    padZero,
    pollingInterval,
    icon,
    leftClick,
    rightClick,
    middleClick,
    scrollUp,
    scrollDown,
} = options.bar.customModules.updates;

const pendingUpdates: VariableType<string> = Variable(' 0');
const toolTipText = Variable('No updates available');

const processUpdateCount = (value: string): string => {
    const text = JSON.parse(value);

    toolTipText.setValue(text.tooltip);

    const totalUpdates = text.total;

    if (!padZero.value) return totalUpdates;
    return `${totalUpdates.padStart(2, '0')}`;
};

pollVariableBash(
    pendingUpdates,
    [padZero.bind('value')],
    pollingInterval.bind('value'),
    updateCommand.value,
    processUpdateCount,
);

export const Updates = (): BarBoxChild => {
    const updatesModule = module({
        textIcon: icon.bind('value'),
        tooltipText: toolTipText.bind('value'),
        boxClass: 'updates',
        label: pendingUpdates.bind('value'),
        showLabelBinding: label.bind('value'),
        props: {
            setup: (self: Button<Child, Attribute>) => {
                inputHandler(self, {
                    onPrimaryClick: {
                        cmd: leftClick,
                    },
                    onSecondaryClick: {
                        cmd: rightClick,
                    },
                    onMiddleClick: {
                        cmd: middleClick,
                    },
                    onScrollUp: {
                        cmd: scrollUp,
                    },
                    onScrollDown: {
                        cmd: scrollDown,
                    },
                });
            },
        },
    });

    return updatesModule;
};
