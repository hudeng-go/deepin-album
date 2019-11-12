/*
 * Copyright (C) 2016 ~ 2018 Deepin Technology Co., Ltd.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#ifndef ALBUMCREATEDIALOG_H
#define ALBUMCREATEDIALOG_H

#include "dialog.h"
#include "controller/signalmanager.h"

class AlbumCreateDialog : public Dialog
{
    Q_OBJECT
public:
    explicit AlbumCreateDialog(QWidget *parent = 0);

    const QString getCreateAlbumName() const;

signals:
    void albumAdded();

protected:
    void keyPressEvent(QKeyEvent *e) override;

private:
    void createAlbum(const QString &newName);
    const QString getNewAlbumName() const;

private:
    QString m_createAlbumName = "";
};

#endif // ALBUMCREATEDIALOG_H
