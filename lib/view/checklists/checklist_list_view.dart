import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notester/services/cloud/cloud_checklist.dart';
import 'package:notester/utils/app_colors.dart';

typedef ChecklistCallback = void Function(CloudChecklist checklist);

class ChecklistListView extends StatelessWidget {
  final Iterable<CloudChecklist> checklists;
  final ChecklistCallback onTap;
  final ChecklistCallback onLongPress;

  const ChecklistListView({
    super.key,
    required this.checklists,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(15),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1 / 1.3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final checklist = checklists.elementAt(index);
            final completedCount =
                checklist.items.where((item) => item.isChecked).length;
            final totalCount = checklist.items.length;

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: Theme.of(context).primaryColor,
              elevation: 4,
              shadowColor: Theme.of(context).colorScheme.shadow,
              child: InkWell(
                onTap: () => onTap(checklist),
                onLongPress: () => onLongPress(checklist),
                child: GridTile(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (checklist.createdDate != null &&
                            checklist.createdDate!.isNotEmpty)
                          Text(
                            DateFormat.yMMMd()
                                .format(DateTime.parse(checklist.createdDate!)),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 9,
                                      color: Theme.of(context).hintColor,
                                    ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          checklist.title.isEmpty
                              ? 'Untitled Checklist'
                              : checklist.title,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (checklist.items.isNotEmpty)
                                ...checklist.items.take(3).map((item) =>
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        children: [
                                          Icon(
                                            item.isChecked
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            size: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              item.text,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    decoration: item.isChecked
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : null,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              if (checklist.items.length > 3)
                                Text(
                                  '+${checklist.items.length - 3} more',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context).hintColor,
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: totalCount > 0
                                    ? completedCount / totalCount
                                    : 0,
                                backgroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  completedCount == totalCount && totalCount > 0
                                      ? AppColors.cGreen
                                      : Theme.of(context).colorScheme.surface,
                                ),
                                borderRadius: BorderRadius.circular(4),
                                minHeight: 4,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$completedCount/$totalCount',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 10,
                                  ),
                            ),
                            const Spacer(),
                            if (checklist.favourite == true)
                              Icon(
                                Icons.star,
                                color: Theme.of(context).indicatorColor,
                                size: 20,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          childCount: checklists.length,
        ),
      ),
    );
  }
}
